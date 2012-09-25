require 'rexml/document'
require 'rest_client'

doc_root = REXML::Document.new(RestClient.get('http://tokumura:aaaaaa@localhost:3000/exams.xml?patient_id=1&order_date=2012-09-25')).root
puts doc_root


