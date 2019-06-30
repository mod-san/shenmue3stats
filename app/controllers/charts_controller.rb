class ChartsController < ApplicationController
	def fc_json
		connection = PGconn.connect(
			:host 		=> ENV['DB_HOST'],
			:port 		=> ENV['DB_PORT'],
			:dbname 	=> ENV['DB_NAME'],
			:user 		=> ENV['DB_USER'],
			:password => ENV['DB_PASSWORD']
		)
		table_name = ENV['DB_TABLE_NAME']

		@category = []; @data = []

		rows = connection.exec("SELECT * FROM #{table_name} ORDER BY date_and_time_as_int_id ASC")
		rows.each {|row|
			@category.push({:label => row['date']})
			@data.push({:value => row['money_amount']})
		}

		one_string = '1'
		font_size = '12'

		@chart = Fusioncharts::Chart.new({
			:height => 400,
			:width => 800,
			:type => 'scrollline2d',
			:renderAt => 'chart-container',
			:dataSource => {
				:chart => {
					:theme => 'fint',
					:scrollToEnd => one_string,
					:xAxisname => 'Date',
					:yAxisName => 'Amount ($)',
					:numberPrefix => '$',
					:yAxisMaxValue => 11_000_000,
					:formatNumberScale => '0',
					:rotateLabels => one_string,
					:rotateValues => one_string,
					:valueFontSize => font_size
				},
				:categories => [{:category => @category, :fontSize => font_size}],
				:dataset => [{:data => @data}],
				:trendlines => [{
					:line => [
						{
							:startvalue => '7000000',
							:displayvalue= => "Battle System Expanded - AI Battling",
							:color => '#1aaf5d',
							:valueOnRight => one_string,
							:dashed => one_string
						}
					]
				}]
			}
		})
	end
end
