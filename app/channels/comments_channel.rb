class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stream_from "comments_for_question-#{data['question_id']}"
  end
end
