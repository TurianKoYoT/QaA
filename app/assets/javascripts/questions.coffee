$ ->
  questionsList = $(".questions-list")
  
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit-question').show()

  App.cable.subscriptions.create('QuestionsChannel' , {
    connected: ->
      @perform 'follow'
    ,
      
    received: (data) ->
      questionsList.append data
  })
