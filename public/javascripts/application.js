(function($) {
		  

      $(function() {
        
		//vars
		var conveyor = $(".content-conveyor", $("#sliderContent")),
		item = $(".item", $("#sliderContent"));
		//set length of conveyor
		conveyor.css("width", item.length * parseInt(item.css("width")));
				
        //config
        var sliderOpts = {

		  max: (item.length * parseInt(item.css("width"))) - parseInt($(".viewer", $("#sliderContent")).css("width")),
          slide: function(e, ui) { 
            conveyor.css("left", "-" + ui.value + "px");
          }
        };

        //create slider
        $("#slider").slider(sliderOpts);
      });
        
		  
		  
		  
  $(function() {
    var signed_in = $("#authentication").size() == 0,
        show_sign_in_form = function() {
         Shadowbox.open({
            player:'inline',
            content: '#shadow_box_authentication',
            height: 272,
            width: 831 ,
            title: ''
        });
       $("#sb-container").mouseover(function(){
											
         $("#sb-container #sign_in .inputs li").each(function() {

            var item = $(this),
            label = item.find("label"),
            input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_authentication #sign_in").html();

                        $("#shadow_box_authentication #sign_in").empty();
                        input.focus();
                        $("#shadow_box_authentication #authentication #sign_in").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });

          FB.init(window.api_key, "/xd_receiver.html");
            });
          return false;
        };

    window.add_asset = function(link, markup) {
      var id = new Date().getTime(),
      marker = new RegExp("new_asset_index", "g");

      $(link).before(markup.replace(marker, id));
    };

    window.remove_asset = function(link) {
      var asset = $(link).parent("li");
      asset.find("input[type=hidden]").val(1);
      asset.removeClass("asset").hide();
    };

    $("#decline_plagg_link").click(function() {

        Shadowbox.open({
            player:'inline',
            content: '#shadow_box_decline',
            height: 302,
            width: 955,
            title: ''
        });

            $("#sb-container").mouseover(function(){
               $("#sb-container #description .inputs li").each(function() {

                    var item = $(this),
                    label = item.find("label"),
                    input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_decline #description").html();

                        $("#shadow_box_decline #description").empty();
                        input.focus();
                        $("#shadow_box_decline #decline #description").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });
             });

      return false;
    })

    if (!signed_in) {
      var form = $("#authentication form");
      
      form.submit(function() {
        $.ajax({
          url: form.attr("action"),
          type: "POST",
          data: form.serialize(),
          dataType: "script"
        });

        return false;
      });
    }

    (function() {
      var checkbox = $("#plagg_is_tradeable"),
          button = $("#allow_trading_button");

      if (checkbox.attr("checked"))
         button.addClass("selected");

      if (button.attr("checked"))
        button.addClass("selected");

      button.click(function() {
        button.toggleClass("selected");

        if (checkbox.attr("checked")) 
          checkbox.removeAttr("checked");
        else
          checkbox.attr("checked", "checked");

        return false;
      });
    })();

  

    $("#new_session_link").click(show_sign_in_form);

    (function() {
      var new_plagg_link = $("#new_plagg_link");

      if (!signed_in) { new_plagg_link.click(show_sign_in_form); }

      new_plagg_link.hover(
        function() { new_plagg_link.stop().animate({ opacity: 0 }, "slow"); },
        function() { new_plagg_link.stop().animate({ opacity: 1 }, "slow"); }
      );
    })();
    
    $("#contact_tab").click(function() {
     Shadowbox.open({
            player:'inline',
            content: '#shadow_box_contact',
            height: 370,
            width: 850 ,
           	title: ''
        });
               $("#sb-container").mouseover(function(){
                $("#sb-container #send_now .inputs li").each(function() {
                    var item = $(this),
                    label = item.find("label"),
                    input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_contact #send_now").html();

                        $("#shadow_box_contact #send_now").empty();
                        input.focus();
                        $("#shadow_box_contact #contact #send_now").append(div_html);
                        
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });
                });
                         return false;
                    });

    $("#shadow, .modal .cancel").click(function() {
      $(".modal:visible").fadeOut(150, function() {
        $("#shadow").fadeOut(150);
      });
      return false;
    });

    $("#authentication #sign_in .inputs li, #emails #send_now .inputs li, #contacts #send_now .inputs li,  #decline #description .inputs li").each(function() {
      var item = $(this),
      label = item.find("label"),
      input = item.find("input, textarea");

      label.click(function() { input.focus(); });
      input
        .focus(function() { label.hide(); })
        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
    });

    $("#plagg_department_id").change(function() {
      var select = $(this);
      var sel_val=$("#plagg_category_id option:selected").val();

      $.getJSON(
        select.attr("data-categories-uri") + "?department_id=" + select.val(),
        function(data, status) {
          var options = "";
         
          $.each(data, function() {
            options += "<option value=\""
                    +  this["category"]["id"]
                    +  "\">"
                    +  this["category"]["name"]
                    +  "</option>";
          });

          $("#plagg_category_id").empty().append(options).change();
          $("#plagg_category_id").val(sel_val);
       
        }
      );
    }).change();

    $("#plagg_category_id").change(function() {
      var select = $(this);
      var sel_val=$("#plagg_size_id option:selected").val();
      $.getJSON(
        select.attr("data-sizes-uri") + "?category_id=" + select.val(),
        function(data, status) {
          var options = "";

          $.each(data, function() {
            options += "<option value=\""
                    +  this["size"]["id"]
                    +  "\">"
                    +  this["size"]["name"]
                    +  "</option>";
          });

          $("#plagg_size_id").empty().append(options);
          $("#plagg_size_id").val(sel_val);
        }
      );
    });

    (function() {
      var target = ($("#authentication").size() > 0) ? "#shadow_box_authentication" : "#shadow_box_suggestion";
      $("#trade_plagg_link").click(function() {
     if( target == "#shadow_box_suggestion"){
		Shadowbox.open({
            player:'inline',
            content: target,
            height: 370,
            width: 850 ,
           	title: '' });}
        else
        {
            Shadowbox.open({
            player:'inline',
            content: target,
            height: 272,
            width: 831 ,
            title: ''
        });
	
			
        $("#sb-container").mouseover(function(){
         $("#sb-container #sign_in .inputs li").each(function() {

            var item = $(this),
            label = item.find("label"),
            input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_authentication #sign_in").html();

                        $("#shadow_box_authentication #sign_in").empty();
                        input.focus();
                        $("#shadow_box_authentication #authentication #sign_in").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });

          FB.init(window.api_key, "/xd_receiver.html");
       });

        }
       
        return false;
      });
    })();

    (function() {
      var target = "#shadow_box_contacts";
      $("#contact_now_link").click(function() {
        Shadowbox.open({
            player:'inline',
            content: target,
            height: 370,
            width: 850 ,
           	title: '' });
            $("#sb-container").mouseover(function(){
                $("#sb-container #send_now .inputs li").each(function() {

                    var item = $(this),
                    label = item.find("label"),
                    input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_contacts #send_now").html();

                        $("#shadow_box_contacts #send_now").empty();
                        input.focus();
                        $("#shadow_box_email #shadow_contacts #send_now").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });
            });
        return false;
      });
    })();


 (function() {
      var target = "#shadow_box_email";
      $("#email_now_link").click(function() {
         Shadowbox.open({
            player:'inline',
            content: target,
            height: 398,
            width: 850 ,
            title: ''});

           $("#sb-container").mouseover(function(){
               $("#sb-container #send_now .inputs li").each(function() {

                    var item = $(this),
                    label = item.find("label"),
                    input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_email #send_now").html();

                        $("#shadow_box_email #send_now").empty();
                        input.focus();
                        $("#shadow_box_email #shadow_email #send_now").append(div_html);
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });
            });
        return false;
      });
    })();



 (function() {
      var target = ($("#authentication").size() > 0) ? "#shadow_box_authentication" :"vote";
      label = $("#vote").find("label");
      if (label.text() == '0'){
        label.hide()
        }
      $("#vote_plagg_link").click(function() {
      if( target == "#shadow_box_authentication"){
         Shadowbox.open({
            player:'inline',
            content: target,
            height: 272,
            width: 831 ,
           	title: ''
        });
        $("#sb-container").mouseover(function(){
         $("#sb-container #sign_in .inputs li").each(function() {

            var item = $(this),
            label = item.find("label"),
            input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_authentication #sign_in").html();

                        $("#shadow_box_authentication #sign_in").empty();
                        input.focus();
                        $("#shadow_box_authentication #authentication #sign_in").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });

          FB.init(window.api_key, "/xd_receiver.html");
            });
            }

      else{
        $.ajax({
            type: "GET",
            url: "vote_plagg/" + $("#vote_plagg_link").attr("value"),
            dataType: "json",
            success: function(json){
                var $vote_button = $('#vote_plagg_link');
                $vote_button.fadeOut('slow', function () {
                  $vote_button.fadeIn('slow');
                });
                label = $("#vote").find("label");
                label.text(json);
                if (label.is(':hidden')){
                  label.fadeIn('slow');
                }
            }
        });
        }
        return false;
      });
    })();

(function() {
      var target = ($("#authentication").size() > 0) ? "#plagg_video" : "#plagg_video";
      $("#plagg_video_link").click(function() {
        $("#shadow").fadeIn(150, function() {
          $(target).fadeIn(200);

        $("#plagg_video embed").each(function(){
            var sr = $(this).attr('src')+"&autoplay=1&fs=1&rel=0" ;
            $(this).attr('src',sr) ;
        });

$("#plagg_video embed").attr('allowfullscreen','true');
$("#plagg_video embed").attr('allowscriptaccess','always') ;

 $("#plagg_video object").append("<param name='allowFullScreen' value='true'></params> <param name='allowscriptaccess' value='always'></params>");

        });
        return false;
      });
    })();

    (function() {
      var target = ($("#authentication").size() > 0) ? "#shadow_box_authentication" : "#plagg_preview";
      $("#preview_link").click(function() {



      $(".title").text($("#plagg_title").val());
      $(".price").text($("#plagg_price").val());
     
      $(".department").text($("#plagg_department_id option:selected").text()+" " + $("#plagg_category_id option:selected").text() );
      $(".description").text($("#plagg_description").val());
      $(".size").text($("#plagg_size_id option:selected").text() );

      var tag="";
       $("#testCheck :checked").each(function() {
            tag += ($("label[for=plagg_tag_ids_"+ $(this).val() +"]").text());
	                  });
      tag=tag.replace("Season","");
      tag=tag.replace("Occasion","");
      var tags;
      tags=tag.split("Condition")

      $(".tags").text(tags[0]);
 
      $(".conditions").text(tags[1]);

              
      if( target == "#plagg_preview"){
            $("#shadow").fadeIn(150, function() {
            $(target).fadeIn(200);
            });
        var preview = $("#plagg #preview");

  		if (preview.size() == 0)
  		  return ;

  		var
  		  carousel = preview.find("#carousel"),
  		  next = preview.find("#next"),
  		  previous = preview.find("#previous"),
  		  cursor = preview.find("#cursor"),
  		  previews = preview.find(".preview"),
  		  thumbs = $("#plagg .miniview img"),
  		  width = 300,
  		  images = previews.size(),
  		  offset = preview.offset(),
  		  l = offset.left,
  		  t = offset.top;

  		 show_cursor = function() { cursor.show(); },
  		 hide_cursor = function() { cursor.hide(); },


  		 move_to = function(n) {
  		   var nxt = (n == images - 1) ? "hide" : "show",
  		       prv = (n == 0) ? "hide" : "show";

  		   carousel
  		     .data("current", n)
  		     .animate({ marginLeft: width * (-n) });

  		   next[nxt]();
  		   previous[prv]();
  		 },

  		 zoom_in = function() {
  		   var pvw = $(this),
  		       img = pvw.find("img"),
  		       src = img.attr("src");

  		   img.attr("src", src.replace("/preview/", "/zoom/"))
  		   cursor.toggleClass("out");

  		   if (images > 0) {
  		     next.hide();
  		     previous.hide();
  		   }

  		   pvw
  		     .bind("mousemove.zoom", function(e) {
  		       img.css({
  		         left: l - e.pageX + 252,
  		         top: t - e.pageY - 779.5
  		       });
              })
  		     .unbind("click")
  		     .click(zoom_out);
  		 },

  		 zoom_out = function() {
  		   var pvw = $(this),
  		       img = pvw.find("img"),
  		       src = img.attr("src");

  		   img
  		     .css({ left: 0, top: 0 })
  		     .attr("src", src.replace("/zoom/", "/preview/"))
  		   cursor.toggleClass("out");

  		   if (images > 0)
  		     move_to(carousel.data("current"));

  		   pvw
  		     .unbind("mousemove.zoom")
  		     .unbind("click")
  		     .click(zoom_in);
  		 };

  		previews.each(function() {
  		      $(this).click(zoom_in);
  		    });

  		    carousel.css("width", previews.size() * width)
  	               .data("current", 0);

       thumbs.each(function(i) {
         $(this).click(function() {
           if (cursor.hasClass("out"))
             previews.eq(carousel.data("current")).click();

           move_to(i);
           return false;
         });
       });

       preview
         .mouseenter(show_cursor)
         .mouseleave(hide_cursor)
         .mousemove(function(e) {
           cursor.css({
             left: e.pageX - l + 12,
             top: e.pageY - t + 12
           });
         });

       next
         .mouseover(hide_cursor)
         .mouseout(show_cursor)
         .click(function(e) {
                move_to((carousel.data("current") + 1) % images);
                return false;
         });

       previous
         .mouseover(hide_cursor)
         .mouseout(show_cursor)
         .click(function(e) {
           move_to((carousel.data("current") - 1 + images) % images);
           return false;
         });

     if (images > 1)
       next.show();
      


}
        else
        {
            Shadowbox.open({
            player:'inline',
            content: target,
            height: 272,
            width: 831 ,
           	title: ''
            });
    $("#sb-container").mouseover(function(){
         $("#sb-container #sign_in .inputs li").each(function() {

            var item = $(this),
            label = item.find("label"),
            input = item.find("input, textarea");

                    label.click(function() {
                        var div_html=$("#shadow_box_authentication #sign_in").html();

                        $("#shadow_box_authentication #sign_in").empty();
                        input.focus();
                        $("#shadow_box_authentication #authentication #sign_in").append(div_html);
                        //alert("haii");
                         return false;
                    });
                    input
                        .focus(function() { label.hide();})
                        .blur(function() { if ($.trim($(this).val()).length == 0) { label.show(); } });
                });

          FB.init(window.api_key, "/xd_receiver.html");
            });

        }
    
       

        return false;
      });
 })();

    $("#new_suggestions span").mouseover(function(){
        document.body.style.cursor = 'pointer';
    });

    $("#new_suggestions span").mouseout(function(){
        document.body.style.cursor = 'auto';
    });

    $("#new_suggestions span").click(function(){
        window.location.href = "/notifications";
    });

     $("#new_monitoring span").mouseover(function(){
        document.body.style.cursor = 'pointer';
    });

    $("#new_monitoring span").mouseout(function(){
        document.body.style.cursor = 'auto';
    });

    $("#new_monitoring span").click(function(){
        window.location.href = "/notifications";
    });

    $("#view_notifications_link").click(function() {
      $.getJSON(
        $(this).find("a").attr("data-unseen-uri"),
        function(data, status) {
          $("#new_suggestions span").text(data["offer_count"] + " new");
          $("#new_suggestions time").text(data["offer_time"]);
          $("#new_monitoring span").text(data["watching_count"] + " new");
          $("#new_monitoring time").text(data["watching_time"]);
          if( $("#view_notifications_link").hasClass("selected"))
            {
                $("#notification_popup").hide();
                $("#view_notifications_link").removeClass("selected");
            }
          else
            {
                $("#notification_popup").show();
                $("#view_notifications_link").addClass("selected");
            }
        }
      );
      return false;
    });

  
    $("#preview_plagg_submit").click(function() {
      document.forms["new_plagg"].submit();
    });

     $("#view_no_notifications_link").click(function() {
      $.getJSON(
        $(this).find("a").attr("data-unseen-uri"),
        function(data, status) {
          $("#new_suggestions span").text(data["offer_count"] + " new");
          $("#new_monitoring span").text(data["watching_count"] + " new");
          if( $("#view_no_notifications_link").hasClass("selected"))
            {
                $("#notification_popup").hide();
                $("#view_no_notifications_link").removeClass("selected");
            }
          else
            {
                $("#notification_popup").show();
                $("#view_no_notifications_link").addClass("selected");
            }
        }
      );
      return false;
    });

    $("#notification_popup .title").click(function() {
      $("#notification_popup").hide();
       $("#view_notifications_link").removeClass("selected");
       $("#view_no_notifications_link").removeClass("selected");
      return false;
    });

    (function() {

     if($("#plagg_preview").length != 0)
        return;
      var preview = $("#plagg #preview");

      if (preview.size() == 0)
        return;

      var
        carousel = preview.find("#carousel"),
        next = preview.find("#next"),
        previous = preview.find("#previous"),
        cursor = preview.find("#cursor"),
        previews = preview.find(".preview"),
        thumbs = $("#plagg .miniview img"),
        width = 300,
        images = previews.size(),
        offset = preview.offset(),
        l = offset.left,
        t = offset.top,

        show_cursor = function() { cursor.show(); },
        hide_cursor = function() { cursor.hide(); },

        move_to = function(n) {
          var nxt = (n == images - 1) ? "hide" : "show",
              prv = (n == 0) ? "hide" : "show";

          carousel
            .data("current", n)
            .animate({ marginLeft: width * (-n) });

          next[nxt]();
          previous[prv]();
        },

        zoom_in = function() {
          var pvw = $(this),
              img = pvw.find("img"),
              src = img.attr("src");

          img.attr("src", src.replace("/preview/", "/zoom/"))
          cursor.toggleClass("out");

          if (images > 0) {
            next.hide();
            previous.hide();
          }

          pvw
            .bind("mousemove.zoom", function(e) {
              img.css({
                left: l - e.pageX,
                top: t - e.pageY
              });
            })
            .unbind("click")
            .click(zoom_out);
        },

        zoom_out = function() {
          var pvw = $(this),
              img = pvw.find("img"),
              src = img.attr("src");

          img
            .css({ left: 0, top: 0 })
            .attr("src", src.replace("/zoom/", "/preview/"))
          cursor.toggleClass("out");

          if (images > 0)
            move_to(carousel.data("current"));

          pvw
            .unbind("mousemove.zoom")
            .unbind("click")
            .click(zoom_in);
        };

      previews.each(function() {
        $(this).click(zoom_in);
      });

      carousel.css("width", previews.size() * width)
              .data("current", 0);

      thumbs.each(function(i) {
        $(this).click(function() {
          if (cursor.hasClass("out"))
            previews.eq(carousel.data("current")).click();

          move_to(i);
          return false;
        });
      });

      preview
        .mouseenter(show_cursor)
        .mouseleave(hide_cursor)
        .mousemove(function(e) {
          cursor.css({
            left: e.pageX - l + 12,
            top: e.pageY - t + 12
          });
        });

      next
        .mouseover(hide_cursor)
        .mouseout(show_cursor)
        .click(function(e) {
          move_to((carousel.data("current") + 1) % images);
          return false;
        });

      previous
        .mouseover(hide_cursor)
        .mouseout(show_cursor)
        .click(function(e) {
          move_to((carousel.data("current") - 1 + images) % images);
          return false;
        });

    if (images > 1)
      next.show();

    })();

    $('#user_location').autocomplete('/locations.js');
    $('#filter_location').autocomplete('/locations.js');
    $('#brand_names').autocomplete('/brand_names.js');

	     	
  });



})(jQuery);
