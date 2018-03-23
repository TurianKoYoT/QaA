$ ->
  answers = $(".answers")

  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()
  
  App.cable.subscriptions.create('AnswersChannel' , {
    connected: ->
      question_id = $(".question").data("question_id");
      @perform('follow', { question_id: question_id })
    ,
      
    received: (data) ->
      answers.append(JST['templates/answer']({
        answer: data.answer
        question: data.question
        attachments: data.attachments
      }))
  })
