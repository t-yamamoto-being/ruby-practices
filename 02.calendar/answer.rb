#!/usr/bin/env ruby
require 'date'
require 'optparse'

class Calender
  attr_accessor :target_date

  def initialize(year = Date.today.year, month = Date.today.mon)
    @target_date = Date.new(year, month, 1)
  end
  
  def show_calender()
    puts (@target_date.mon.to_s + "月 " + @target_date.year.to_s) .center(20)
    puts "日 月 火 水 木 金 土"

    days_in_month = Date.new(@target_date.year,@target_date.mon,-1).day
    first_day_of_week = Date.new(@target_date.year,@target_date.mon,1).wday
    
    #最初の行の前にスペース挿入
    print "   " * first_day_of_week

    (1..days_in_month).each do |day|
      printf("%2d ", day) 
      puts if (day + first_day_of_week) % 7 == 0 #7日毎に改行
    end
    puts
  end
end

# コマンドラインオプションの解析
options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ruby calender.rb [-y YEAR] [-m MONTH]"

  opts.on("-y YEAR", "--year YEAR", "Specify the year") do |y|
    options[:year] = y.to_i
  end

  opts.on("-m MONTH", "--month MONTH", "Specify the month") do |m|
    options[:month] = m.to_i
  end
end.parse!

# デフォルト値の設定（指定がなければ現在の年月）
year = options[:year] || Date.today.year
month = options[:month] || Date.today.mon

# 入力値のバリデーション
if (year < 1970 || year > 2100) && (month < 1 || month > 12) 
  puts "エラー: 年は 1970 〜 2100 の範囲で指定してください。"
  puts "エラー: 月は 1 ～ 12 の範囲で指定してください。"
  exit 1
elsif year < 1970 || year > 2100
  puts "エラー: 年は 1970 ～ 2100 の範囲で指定してください。"
  exit 1
elsif month < 1 || month > 12
  puts "エラー: 月は 1 ～ 12 の範囲で指定してください。"
  exit 1
end

calender = Calender.new(year, month)
calender.show_calender
