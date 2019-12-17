var LARGE_WINDOW_WIDTH = 960,
    POSITION_OFFSET_LEFT = 127,
    POSITION_OFFSET_TOP = 50,
    timeout;
function closeAllToolTips() {
    $('.architecture-tooltip-content').removeClass('open-click open-hover');
}
function openToolTip(
    $this,
    offset,
    $toolTipContent,
    classToRemove,
    classToAdd,
    windowWidth,
    wasClicked) {
    var top = offset.top + POSITION_OFFSET_TOP,
        left = offset.left - POSITION_OFFSET_LEFT;
    if (windowWidth >= LARGE_WINDOW_WIDTH) {
        $toolTipContent.offset({
            left: left,
            top: top
        });
        $toolTipContent.removeClass(classToRemove).addClass(classToAdd);
        if (wasClicked) {
            $(window).on('resize', closeAllToolTips);
        }
    }
}

function closeToolTip($toolTipContent, classesToRemove, wasClicked) {
    $toolTipContent.removeClass(classesToRemove);
    if (!$toolTipContent.hasClass('open-click')) {
        $toolTipContent.removeAttr('style');
    }
    if (wasClicked) {
        $(window).off('resize', closeAllToolTips);
    }
}

$(document).ready(function(){
    $('.architecture-tooltip-trigger').click(function (e) {
        var offset = $(this).offset(),
            number = $(this).children('text').text().trim(),
            $toolTipContent = $('#architecture-tooltip-' + number),
            $this = $(this),
            windowWidth = $(window).width();
        e.preventDefault();
        if ($toolTipContent.hasClass('open-click')) {
            closeToolTip($toolTipContent, 'open-click open-hover', true);
        } else {
            openToolTip($this, offset, $toolTipContent, 'open-hover', 'open-click', windowWidth, true);
        }
    });
    $('.architecture-tooltip-trigger').hover(function () {
        var $this = $(this);
        var offset = $(this).offset(),
            number = $(this).children('text').text().trim(),
            $toolTipContent = $('#architecture-tooltip-' + number),
            windowWidth = $(window).width();
        openToolTip($this, offset, $toolTipContent, 'open-click', 'open-hover', windowWidth, false);
    }, function () {
        var number = $(this).children('text').text().trim(),
            $toolTipContent = $('#architecture-tooltip-' + number);
        closeToolTip($toolTipContent, 'open-hover', false);
    });

    var parent = $('text:contains(\'1\')').parent('.architecture-tooltip-trigger')
            .first(),
        parentOffset = $('text:contains(\'1\')')
            .parent('.architecture-tooltip-trigger')
            .first().offset(),
        windowWidth = $(window).width();
    if (windowWidth >= LARGE_WINDOW_WIDTH &&
        $('.architecture-tooltip-trigger').length > 0) {
        openToolTip(parent, parentOffset, $('#architecture-tooltip-1'), 'open-hover', 'open-click', windowWidth, true);
        timeout = setTimeout(function () {
            $('#architecture-tooltip-1').fadeOut(1000, function () {
                closeToolTip($('#architecture-tooltip-1'), 'open-click open-hover', false);
            });
        }, 2000);
    }
}); 
