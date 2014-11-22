function validateEmail(email){
    re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

$(document).ready(function () {
  $(".user_actions .register_form #email_field").keyup(function () {
    email_inputted = $(this).val();
    if(validateEmail(email_inputted)){
      $(".user_actions .register_form #submit_button").removeClass("disabled")
    }else{
      if(!$(".user_actions .register_form #submit_button").hasClass("disabled"))
        $(".user_actions .register_form #submit_button").addClass("disabled")
    }
  });
});
