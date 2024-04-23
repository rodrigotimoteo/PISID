<?php

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lab Rats</title>
    <!-- Include jQuery library -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        
    </style>
</head>
<body>

<div>
    <div>
        <h2>Lab Rats</h2>
        <p>Landing Page</p>
    </div>
</div>

<div>
    <a href="loginPage.php" class="button">Login</a>
</div>

<!-- JavaScript/jQuery code -->
<script>
    $(document).ready(function() {
        $('#clickMe').click(function(){
            let el = $('.pop-up');
            newone = el.clone(true);
            newone.removeClass("animation-beginn").addClass("animation-click");
            el.before(newone);
            $('.pop-up').last().remove();
        });

        $('.close').click(function(){
            let el = $('.pop-up');
            newone = el.clone(true);
            newone.removeClass("animation-beginn").removeClass("animation-click").addClass("animation-close");
            el.before(newone);
            $('.pop-up').last().remove();
        });

        $(document).on('click', function(){
            let y = $('.pop-up').first().position().top;
            if (y > 1200 && !($('.pop-up').hasClass("animation-beginn") && $('.pop-up').hasClass("animation-click"))) {
                let el = $('.pop-up');
                newone = el.clone(true);
                newone.removeClass("animation-close").addClass("animation-beginn");
                el.before(newone);
                $('.pop-up').last().remove();
            }
        });
    });
</script>

</body>
</html>

