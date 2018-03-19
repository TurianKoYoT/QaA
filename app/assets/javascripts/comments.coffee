$ ->
  $('.add-comment-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    $('form#add-comment-' + commentable_type + '-' + commentable_id).show()

  App.cable.subscriptions.create('CommentsChannel' , {
    connected: ->
      question_id = $(".question").data("question_id");
      @perform('follow', { question_id: question_id })
    ,
      
    received: (data) ->
      comment = data.comment
      commentId = '.comments-' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id
      $(commentId).append(JST['templates/comment']({
        comment: comment
      }))
  })
