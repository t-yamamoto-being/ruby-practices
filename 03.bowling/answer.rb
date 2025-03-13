#!/usr/bin/env ruby

class BowlingScore
  def initialize(score)
    @shots = parse_score(score)
  end

  def total_points
    total_points = 0
    frame_index = 0
    frame_count = 0

    while frame_count < 9
      if @shots[frame_index] == 10 # ストライク
        total_points += 10 + @shots[frame_index + 1].to_i + @shots[frame_index + 2].to_i
        frame_index += 1
      elsif @shots[frame_index].to_i + @shots[frame_index + 1].to_i == 10 # スペア
        total_points += 10 + @shots[frame_index + 2].to_i
        frame_index += 2
      else
        total_points += @shots[frame_index].to_i + @shots[frame_index + 1].to_i
        frame_index += 2
      end
      frame_count += 1
    end
    total_points += final_frame_points(frame_index)

    total_points
  end

  private

  def parse_score(score)
    score.split(',').map { |s| s == 'X' ? 10 : s.to_i }
  end

  def final_frame_points(frame_index)
    @shots[frame_index..].sum.to_i
  end
end

score = ARGV[0]
puts BowlingScore.new(score).total_points
