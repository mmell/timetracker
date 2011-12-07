// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var current_minutes;
var activity_timer_obj;
var activity_timer_delay = 60000;
//var timer_highlight = "{ startcolor: '#ffbbbb', endcolor: '#ffffff' } ";

function IncrementCurrentActivityTimer()
{
  current_minutes = current_minutes + 1;
//  alert('timer is ' + current_minutes);
  $('#activity_timer_minutes').html(current_minutes.toFixed(0));
//  $('activity_timer_minutes').animate( timer_highlight, 2000,  );
  activity_timer_obj = self.setTimeout("IncrementCurrentActivityTimer()", activity_timer_delay);
}

function StartCurrentActivityTimer(start_minutes)
{
  current_minutes = start_minutes;
  $('#activity_timer_minutes').html( current_minutes);
  activity_timer_obj = self.setTimeout("IncrementCurrentActivityTimer()", activity_timer_delay);
}
