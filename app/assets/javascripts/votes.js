$(document).ready(function(){
  $('.vote-up, .vote-down').bind('ajax:success', function(e, data, status, xhr) {
    var json = $.parseJSON(xhr.responseText);
    var vote = json.vote;
    var votable = json.votable;
    var voteClass = vote.votable_type.toLowerCase();
    var ratingId = '#rating-' + voteClass + '-' + votable.id;
    var voteButtonsId = '#vote-' + voteClass + '-' + votable.id;
    $(ratingId).html('Rating ' + votable.rating);
    $(voteButtonsId + ' .vote-up').hide();
    $(voteButtonsId + ' .vote-down').hide();
    $(voteButtonsId + ' .reset-vote').show();
  });

  $('.reset-vote').bind('ajax:success', function(e, data, status, xhr) {
    var json = $.parseJSON(xhr.responseText);
    var vote = json.vote;
    var votable = json.votable;
    var voteClass = vote.votable_type.toLowerCase();
    var ratingId = '#rating-' + voteClass + '-' + votable.id;
    var voteButtonsId = '#vote-' + voteClass + '-' + votable.id;
    $(ratingId).html('Rating ' + votable.rating);
    $(voteButtonsId + ' .vote-up').show();
    $(voteButtonsId + ' .vote-down').show();
    $(voteButtonsId + ' .reset-vote').hide();
  });
});
