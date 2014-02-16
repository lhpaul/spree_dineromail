require 'happymapper'
require 'httparty'
module Dineromail
  class StatusReport
    include ::HappyMapper

    tag 'reporte'
    element :report_status, Integer, :tag => 'estadoreporte'
    has_many :operations, Operation

    VALID_REPORT_STATUS = 1
    MALFORMED_REPORT_STATUS = 2
    INVALID_ACCOUNT_NUMBER_REPORT_STATUS = 3
    INVALID_PASSWORD_REPORT_STATUS = 4
    INVALID_REQUEST_TYPE_STATUS = 5
    INVALID_TRANSACTION_ID_REQUEST_STATUS = 6
    INVALID_PASSWORD_OR_ACCOUNT_NUMBER_REQUEST_STATUS = 7
    TRANSACTION_NOT_FOUND_REQUEST_STATUS = 8

    def valid_report?
      report_status == VALID_REPORT_STATUS
    end


    def self.get_report_for(transaction_id,options = {})
      options = options.symbolize_keys
      ipn_url = options[:ipn_webservice_url] || DINEROMAIL['ipn_url']
      request_data = xml_request_for(transaction_id,options)
      response = ::HTTParty.post ipn_url , :body => {:DATA => request_data}
      self.parse response.body
    end

    def self.parse(xml)
      #Convert tags to lowercase
      xml = xml.gsub(/<(.*?)[> ]/){|tag| tag.downcase}
      super(xml)
    end

    def self.xml_request_for(transaction_id,options = {})
      options = options.symbolize_keys
      account_number = options[:account_number] || ENV["dineromail_account_number"]
      password = options[:password] || ENV["dineromail_password"]
      "<REPORTE>
            <NROCTA>#{account_number}</NROCTA>
            <DETALLE>
            <CONSULTA>
              <CLAVE>#{password}</CLAVE>
              <TIPO>1</TIPO>
              <OPERACIONES>
                <ID>#{transaction_id}</ID>
              </OPERACIONES>
            </CONSULTA>
            </DETALLE>
          </REPORTE>"
    end

  end
end