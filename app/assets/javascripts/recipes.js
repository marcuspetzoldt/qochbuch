/* Upload pictures */
$(document).on('click', 'img#preview_pic1', function() { $('input#upload_pic1').click() });
$(document).on('click', 'img#preview_pic2', function() { $('input#upload_pic2').click() });
$(document).on('click', 'img#preview_pic3', function() { $('input#upload_pic3').click() });

/* Upload Spinner */
$(document).on('change', 'input#upload_pic1', function() {
    $('img#preview_pic1').attr('src', $('#spinner').attr('src')).css('margin', '50px 100px 50px 100px')
});
$(document).on('change', 'input#upload_pic2', function() {
    $('img#preview_pic2').attr('src', $('#spinner').attr('src')).css('margin', '50px 100px 50px 100px')
});
$(document).on('change', 'input#upload_pic3', function() {
    $('img#preview_pic3').attr('src', $('#spinner').attr('src')).css('margin', '50px 100px 50px 100px')
});

/* Cloudinary Preview */
$(document).on('cloudinarydone', '.cloudinary-fileupload', function(e, data) {
    $(this).parent().children().first().html(
    $.cloudinary.image(data.result.public_id,
        { format: data.result.format, version: data.result.version,
            crop: 'fill', width: 600, height: 400 }).css('margin', '0')
    );
    return true;
});

/* Managing tag clouds */
/* Region */
$(document).on('click', 'span.region_usable_tag_cloud', function() {
    move_tag(this, 'region_usable', 'region_used');
    refresh_tag_list('region_used')
});
$(document).on('click', 'span.region_used_tag_cloud', function() {
    move_tag(this, 'region_used', 'region_usable');
    refresh_tag_list('region_used')
});

/* Tags */
$(document).on('click', 'span.tag_usable_tag_cloud', function() {
    move_tag(this, 'tag_usable', 'tag_used');
    refresh_tag_list('tag_used')
});
$(document).on('click', 'span.tag_used_tag_cloud', function() {
    move_tag(this, 'tag_used', 'tag_usable');
    refresh_tag_list('tag_used')
});

/* Evolve Ingredients Form */
$(document).on('click', 'a[name=add_ingredient]', function() {
    var $new_ingredient = $(this).parent().parent().children().first().clone();

    $new_ingredient.css('display', 'inline-block');
    $(this).attr('name', 'remove_ingredient');
    $(this).html('<i class="icon icon-remove"></i>');
    $(this).parent().after($new_ingredient);
    $(this).parent().next().children().first().focus();
    return false;
});

$(document).on('click', 'a[name=remove_ingredient]', function() {
    $(this).parent().remove()
    return false;
});

/* Calculate portion */
$(document).on('change', 'select#portion', function() {
    $(this.form).submit();
});

$(document).on('change', 'select#recipe_portion', function() {
    if (this.value == 1) {
        $('span#portions').html($('span#portion_singular').html())
    } else {
        $('span#portions').html($('span#portion_plural').html())
    }
});

/* Busy spinner */
$(document).on('submit', 'form#recipe_form', function() {
    var $busy = $('div#busy');
    $busy.prepend('<div style="position:absolute; top: 0; left:0; width:100%; height: '+$('html').height()+'px; background-color:gray; opacity: .8;"></div>')
    $busy.css('visibility', 'visible').fadeIn(850);
});

/* Disable submit on ENTER in Ingredientslist */
$(document).on('keypress', 'input.noenter', function(event) {
    if (event.which == 13) {
        event.preventDefault();
    }
});

function refresh_tag_list(tag) {
    var $value = ''

    $('span.'+tag+'_tag_cloud').each( function(index, element) {
        if ($value) {
            $value = $value + ' ';
        }
        $value = $value + $(element).attr('name');
    });
    $('input#i'+tag).val($value);
}

function move_tag(tag, from, to) {
    var $found = false;

    $(tag).removeClass(from+'_tag_cloud');
    $(tag).addClass(to+'_tag_cloud');
    $span = $('span.'+to+'_tag_cloud')
    $span.each( function(index, element) {
        if ($(element).text() > $(tag).text()) {
            $(element).before($(tag));
            $found = true;
            return false;
        }
    });
    if (!$found) {
        $('div#'+to).append($(tag))
    }
}

$(document).ready( function like_facebook(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/de_DE/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));

$(document).ready( function share_twitter(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0],p=/^http:/.test(d.location)?'http':'https';
    if(d.getElementById(id)) return;
    js=d.createElement(s);
    js.id=id;js.src=p+'://platform.twitter.com/widgets.js';
    fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'twitter-wjs'));


$(document).ready( function() {
    window.___gcfg = {lang: 'de'};
});

$(document).ready( function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/plusone.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
}());
