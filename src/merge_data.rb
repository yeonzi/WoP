#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'json'

gb2312 = JSON.parse File.read('./dict/gb2312.json').force_encoding('UTF-8')
pinyin = JSON.parse File.read('./dict/pinyin.json').force_encoding('UTF-8')
wubi86 = JSON.parse File.read('./dict/wubi86.json').force_encoding('UTF-8')
cangjie5 = JSON.parse File.read('./dict/cangjie5.json').force_encoding('UTF-8')
zhengma = JSON.parse File.read('./dict/zhengma.json').force_encoding('UTF-8')
zrm = JSON.parse File.read('./dict/zrm.json').force_encoding('UTF-8')

charset = []

sets = {
	"信息交换用汉字编码字符集 基本集 一级常用字符" => gb2312["class1"],
	"信息交换用汉字编码字符集 基本集 二级常用字符" => gb2312["class2"],
}

sets.each do |set_name, content|
	content.each do |chr|
		char_data = {}
		char_data["字符"] = chr
		char_data["字库"] = set_name

		gb_code = chr.encode('GB2312').ord
		gb_code_h = (gb_code / 256 - 160)
		gb_code_l = (gb_code % 256 - 160)
		char_data["信息交换用汉字编码字符集基本集编码"] = '%02d%02d' % [gb_code_h, gb_code_l]

		char_data["万国码编码"] = chr.encode('GB2312').ord.to_s(16).upcase
		char_data["拼音"] = pinyin[chr]
		char_data["大自然键盘（自然码）形码"] = zrm[chr]
		char_data["五笔字形（王码86版）"] = wubi86[chr]
		char_data["形意检字法（倉頡五代）"] = cangjie5[chr]
		char_data["字根通用码（郑码）"] = zhengma[chr]

		charset << char_data

	end
end

total = charset.length - 1

puts "{"
puts "    \"字符集\": ["
puts "        {"

(0..total).each do |chr_index|
	charset[chr_index].each do |key,value|
		puts "            \"#{key}\": \"#{value}\"," if value.class == String
		puts "            \"#{key}\": #{value},"     if value.class == Array
	end

	puts "            \"字形分解\": []"

	if chr_index == total
		puts "        }"
	else
		puts "        },{"
	end
end

puts "    ]"
puts "}"