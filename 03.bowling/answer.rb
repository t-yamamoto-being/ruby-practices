#!/usr/bin/env ruby

class Bowling
  attr_accessor :scores

  def initialize(score)
    @scores = score.split(',')
  end

  def sum_scores
    # change to scores
    shots = []
    @scores.each do |s|
      shots << if s == 'X'
                 10
               else
                 s.to_i
               end
    end

    # sum total scores
    total_scores = 0
    frame_index = 0
    frame_count = 0

    ## process to the 9th frame
    while frame_count < 9
      if shots[frame_index] == 10 # strike
        total_scores += shots[frame_index + 1].to_i + shots[frame_index + 2].to_i + 10
        frame_index += 1
      elsif shots[frame_index].to_i + shots[frame_index + 1].to_i == 10 # spare
        total_scores += shots[frame_index + 2].to_i + 10
        frame_index += 2
      else
        total_scores += shots[frame_index].to_i + shots[frame_index + 1].to_i
        frame_index += 2
      end
      frame_count += 1
    end
    ## process the 10th frame
    total_scores += shots[frame_index..].sum.to_i

    total_scores
  end
end


bowling = Bowling.new(ARGV[0])
puts bowling.sum_scores

