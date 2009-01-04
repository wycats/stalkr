// Common JavaScript code across your application goes here.

jQuery(function($) {
  $("a.delete").click(function() {
    // jQuery idiom that allows use of 'this' inside the callback
    var self = $(this);
    
    if(confirm("Are you sure you wish to delete this article")) {
      $.post($(this).attr("rel"), {"_method": "delete"}, function(json) {
        self.parents("li:first").remove();
        $("div.notice").html(json.notice);
      }, "json");
    }
    return false;
  });
});