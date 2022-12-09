#!/usr/bin/env ruby

require 'json'
require 'csv'

id = ARGV[0]

file = File.read("../data/transcripts/#{id}.json")
data = JSON.parse(file)

segments = data["actions"][0]["updateEngagementPanelAction"]["content"]["transcriptRenderer"]["content"]["transcriptSearchPanelRenderer"]["body"]["transcriptSegmentListRenderer"]["initialSegments"]

CSV.open("../data/transcripts/#{id}.csv", "wb") do |csv|
    csv << ["ID","startMs","endMs","text"]

    segments.each do |segment|
        csv << [
            id,
            segment["transcriptSegmentRenderer"]["startMs"],
            segment["transcriptSegmentRenderer"]["endMs"],
            segment["transcriptSegmentRenderer"]["snippet"]["runs"][0]["text"]
        ]
    end
end
