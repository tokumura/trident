#!/usr/bin/env ruby
# encoding: utf-8

require 'rubygems'
require 'rexml/document'
require 'rest_client'
require 'uri'
require 'net/http'

Net::HTTP.version_1_2

HOST = "192.168.0.187"
PORT = "8000"
USER = "ormaster"
PASSWD = "ormaster"
CONTENT_TYPE = "application/xml"

#------ ver 4.6
req = Net::HTTP::Post.new("/api21/medicalmod?class=01")
# class :01 
#
#
BODY = <<EOF
<data>
  <record>
	<record name="medicalreq">
		<string name="Patient_ID">00003</string>
		<string name="Perform_Date">2012-09-26</string>
		<string name="Perform_Time">10:00:00</string>
		<string name="Medical_Uid"/>
<!-- ========================================================== -->
<!--                    診療データ                              -->
<!-- ========================================================== -->
	<record name="Diagnosis_Information">
			<string name="Department_Code">01</string>
			<string name="Physician_Code">10001</string>
			<record name="HealthInsurance_Information">
				<string name="InsuranceProvider_Class">006</string>
				<string name="InsuranceProvider_Number">06260434</string>
				<string name="InsuranceProvider_WholeName">組合</string>
				<string name="HealthInsuredPerson_Symbol"></string>
				<string name="HealthInsuredPerson_Number"></string>
				<string name="HealthInsuredPerson_Continuation"/>
				<string name="HealthInsuredPerson_Assistance">3</string>
				<string name="RelationToInsuredPerson">2</string>
				<string name="HealthInsuredPerson_WholeName">日医　太郎</string>
				<string name="Certificate_StartDate">2004-04-01</string>
				<string name="Certificate_ExpiredDate">9999-12-31</string>
			</record>
			<array name="Medical_Information">
				<record>
					<string name="Medical_Class">120</string>
					<string name="Medical_Class_Name">再診</string>
					<string name="Medical_Class_Number">1</string>
					<array name="Medication_info">
						<record>
							<string name="Medication_Code">112007410</string>
							<string name="Medication_Name">再診</string>
							<string name="Medication_Number">1</string>
						</record>
					</array>
				</record>
				<record>
					<string name="Medical_Class">210</string>
					<string name="Medical_Class_Name">内服薬剤</string>
					<string name="Medical_Class_Number">1</string>
					<array name="Medication_info">
						<record>
							<string name="Medication_Code">620001402</string>
							<string name="Medication_Name">グリセリン</string>
							<string name="Medication_Number">2</string>
						</record>
					</array>
				</record>
				<record>
					<string name="Medical_Class">500</string>
					<string name="Medical_Class_Name">手術</string>
					<string name="Medical_Class_Number">1</string>
					<array name="Medication_info">
						<record>
							<string name="Medication_Code">150003110</string>
							<string name="Medication_Name">皮膚、皮下腫瘍摘出術（露出部）（長径２ｃｍ未満）</string>
							<string name="Medication_Number">1</string>
						</record>
						<record>
							<string name="Medication_Code">641210099</string>
							<string name="Medication_Name">キシロカイン注射液１％</string>
							<string name="Medication_Number">3</string>
						</record>
						<record>
							<string name="Medication_Code">840000042</string>
							<string name="Medication_Name">手術○日</string>
							<string name="Medication_Number">15</string>
						</record>
					</array>
				</record>
			</array>
			<array name="Disease_Information">
				<record>
					<string name="Disease_Code">8830052</string>
					<string name="Disease_Name">ＡＣバイパス術後機械的合併症</string>
					<string name="Disease_SuspectedFlag">S</string>
					<string name="Disease_StartDate">2010-11-23</string>
					<string name="Disease_EndDate">2010-11-24</string>
					<string name="Disease_OutCome">D</string>
				</record>
				<record>
					<array name="Disease_Single">
						<record>
						<string name="Disease_Single_Code">8830417</string>
						<string name="Disease_Single_Name">胃炎</string>
						</record>
						<record>
						<string name="Disease_Single_Code">ZZZ8002</string>
						<string name="Disease_Single_Name">の疑い</string>
						</record>
					</array>
					<string name="Disease_StartDate">2010-07-06</string>
					<string name="Disease_EndDate">2010-07-28</string>
					<string name="Disease_OutCome">D</string>
				</record>
			</array>
		</record>
	</record>
  </record>
</data>
EOF

Process.daemon

while true
  doc_root = REXML::Document.new(RestClient.get('http://user:password@localhost:3000/exams.xml?patient_id=1&order_date=2012-09-25')).root
  puts doc_root

  req.content_length = BODY.size
  req.content_type = CONTENT_TYPE
  req.body = BODY
  req.basic_auth(USER, PASSWD)
  puts req.body

  Net::HTTP.start(HOST, PORT) {|http|
    res = http.request(req)
    puts res.body
  }
  sleep 10
  puts "Done. go next."
  $stdout = File.new('/tmp/trident.log', 'a+')
  $stdout.sync = true
end

