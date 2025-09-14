class VotesController < ApplicationController
  def ranking
    total = Vote.count.to_f
    positions = {
      "山形" => { top: 180, left: 220 },
      "宮城" => { top: 120, left: 260 },
      "福島" => { top: 240, left: 270 },
      "岩手" => { top: 100, left: 200 },
      "秋田" => { top: 80, left: 180 },
      "青森" => { top: 40, left: 180 }
    }

    @ranking = Region.all.map do |region|
      count = region.votes.count
      rate = total > 0 ? (count / total * 100).round(1) : 0
      { region: region, count: count, rate: rate, top: positions[region.name][:top], left: positions[region.name][:left] }
    end.sort_by { |r| -r[:count] }
  end
end
