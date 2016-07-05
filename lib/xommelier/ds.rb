# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'
require 'base64'
require 'active_support/core_ext/module/delegation'

module Xommelier
  module DS
    include Xommelier::Xml

    xmlns 'http://www.w3.org/2000/09/xmldsig#', as: :ds
    schema

    class CryptoBinary < DelegateClass(String)
      def self.from_xommelier(value)
        return unless value
        case value
        when %r(\A[a-zA-Z0-9+/]={0,2}\Z)
          new Base64.decode64(value)
        when String
          new value
        else
          new value.to_s
        end
      end

      def inspect
        %(#<#{self.class.name} "#{self}">)
      end

      def raw
        __getobj__
      end

      delegate :to_s, to: :to_xommelier

      def to_xommelier
        Base64.encode64(raw)
      end
    end

    class Element < Xml::Element
      def self.find_element_name
        name.demodulize
      end

      # Defines containing attribute
      def self.attribute(name, options = {})
        options[:as] ||= name.to_s.camelcase
        super(name, options)
      end

      def self.any!(_options = {})
        # TODO: implement <any /> logic
      end

      def self.choice!(_options = {})
        # TODO: implement <choice /> logic
        may do
          yield
        end
      end

      def self.sequence!(_options = {})
        # TODO: implement <choice /> logic
        yield
      end

      def self.has_algorithm(map = {})
        attribute :algorithm, type: Uri, required: true

        const_set(:ALGORITHMS, map)
        map.each do |name, algorithm|
          define_singleton_method("new_#{name}") do |options = {}|
            new(options.merge(algorithm: algorithm))
          end
        end

        define_method(:algorithm_name) do
          map.key(algorithm.to_s)
        end
      end
    end

    class SignatureValue < Element
      attribute :id, optional: true

      text
    end

    class CanonicalizationMethod < Element
      any! ns: :any, count: :any
      has_algorithm(
        omit_comments: 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315',
        with_comments: 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments'
      )
    end

    class SignatureMethod < Element
      element :hmac_output_length, as: 'HMACOutputLength', type: Integer, count: :may
      any! ns: :other, count: :any
      has_algorithm(
        rsa_sha1: 'http://www.w3.org/2000/09/xmldsig#rsa-sha1',
        dsa_sha1: 'http://www.w3.org/2000/09/xmldsig#dsa-sha1'
      )
    end

    class Transform < Element
      choice! count: :any do
        any! ns: :other
        element :xpath, as: 'XPath'
      end
      has_algorithm(
        xslt: 'http://www.w3.org/TR/1999/REC-xslt-19991116',
        xpath: 'http://www.w3.org/TR/1999/REC-xpath-19991116',
        enveloped_signature: 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'
      )
    end

    class Transforms < Element
      element ref: Transform, count: :many
    end

    class DigestMethod < Element
      any! ns: :other, count: :any
      has_algorithm(
        sha1: 'http://www.w3.org/2000/09/xmldsig#sha1'
      )
    end

    class Reference < Element
      element ref: Transforms, count: :may
      element ref: DigestMethod
      element :digest_value, as: 'DigestValue'
      attribute :id, optional: true
      attribute :uri, as: 'URI', type: Uri, optional: true
      attribute :type, type: Uri, optional: true
    end

    class SignedInfo < Element
      element ref: CanonicalizationMethod
      element ref: SignatureMethod
      element ref: Reference, count: :many
      attribute :id, optional: true
    end

    class DSAKeyValue < Element
      sequence! count: :may do
        element :p, as: 'P', type: CryptoBinary
        element :q, as: 'Q', type: CryptoBinary
      end
      element :g, as: 'G', type: CryptoBinary, count: :may
      element :y, as: 'Y', type: CryptoBinary
      element :j, as: 'J', type: CryptoBinary, count: :may
      sequence! count: :may do
        element :seed, as: 'Seed', type: CryptoBinary
        element :pgen_counter, as: 'PgenCounter', type: CryptoBinary
      end
    end

    class RSAKeyValue < Element
      sequence! do
        element :modulus, as: 'Modulus', type: CryptoBinary
        element :exponent, as: 'Exponent', type: CryptoBinary
      end
    end

    class KeyValue < Element
      choice! do
        element ref: DSAKeyValue
        element ref: RSAKeyValue
        any! ns: :other
      end
    end

    class RetrievalMethod < Element
      element ref: Transforms, count: :any
      attribute :uri, as: 'URI', type: URI
      attribute :type, type: URI, optional: true
    end

    class X509IssuerSerial < Element
      element :issuer_name, as: 'X509IssuerName'
      element :serial_number, as: 'X509SerialNumber', type: Integer
    end

    class X509Data < Element
      sequence! count: :many do
        choice! do
          element :issuer_serial, type: X509IssuerSerial
          element :ski, as: 'X509SKI'
          element :subject_name, as: 'X509SubjectName'
          element :certificate, as: 'X509Certificate'
          element :crl, as: 'X509CRL'
          any! ns: :other
        end
      end
    end

    class PGPData < Element
      element :key_id, as: 'PGPKeyID', count: :may
      element :key_packet, as: 'PGPKeyPacket', count: :may
      any! ns: :other, count: :any
    end

    class SPKIData < Element
      element :sexp, as: 'SPKISexp'
      any! ns: :other, count: :may
    end

    class KeyInfo < Element
      choice! count: :many do
        element :key_name, as: 'KeyName'
        element ref: KeyValue
        element ref: RetrievalMethod
        element ref: X509Data
        element ref: PGPData
        element ref: SPKIData
        element :mgmt_data, as: 'MgmtData'
        any! ns: :other
      end
      attribute :id, optional: true
    end

    class Manifest < Element
      element ref: Reference, count: :many
      attribute :id, optional: true
    end

    class SignatureProperty < Element
      choice! do
        any! ns: :other
      end
      attribute :target, type: Uri, optional: true
      attribute :id, optional: true
    end

    class SignatureProperties < Element
      element ref: SignatureProperty, count: :many
      attribute :id, optional: true
    end

    class Object < Element
      any! ns: :any, count: :any
      attribute :id, optional: true
      attribute :mime_type, optional: true
      attribute :encoding, type: Uri, optional: true
    end

    class Signature < Element
      element ref: SignedInfo
      element ref: SignatureValue
      element ref: KeyInfo, count: :may
      element ref: Object, count: :any

      attribute :id, optional: true
    end
  end
end
