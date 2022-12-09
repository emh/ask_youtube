#!/usr/bin/env ruby

require 'json'
require 'csv'
require 'net/http'
require 'uri'

id = ARGV[0]

file = File.read("../data/transcripts/#{id}.json")
data = JSON.parse(file)

segments = data["actions"][0]["updateEngagementPanelAction"]["content"]["transcriptRenderer"]["content"]["transcriptSearchPanelRenderer"]["body"]["transcriptSegmentListRenderer"]["initialSegments"]

text = ""

segments.each do |segment|
    snippet = segment["transcriptSegmentRenderer"]["snippet"]["runs"][0]["text"]
    text += ' ' + snippet
end

uri = URI('http://bark.phon.ioc.ee/punctuator')
res = Net::HTTP.post_form(uri, 'text' => text)

punctuated = res.body

sentences = punctuated.split('.')

CSV.open("../data/transcripts/#{id}.sentences.csv", "wb") do |csv|
    csv << ["ID","index","text"]

    sentences.each_with_index do |sentence, i|
        sentence.strip!

        if sentence.length > 0
            csv << [
                id,
                i,
                sentence
            ]
        end
    end
end
