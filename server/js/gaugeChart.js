! function (jet, $, server, util, debug) {
    "use strict";
 
    jet.gauge = {
        init: function (pRegionId, pHeight, pOrientation, pApexAjaxIdentifier) {
            require(["ojs/ojcore", "jquery", "ojs/ojgauge"], function (oj, $) {
                server.plugin(pApexAjaxIdentifier, {}, {
                    success: function (pData) {
                            $("#" +pRegionId).empty();   
                            var gaugeDiv, html, i = 0, w;
                            w = (pOrientation == "Horizontal")?Math.floor( $("#" + pRegionId).width() / pData.data.length ) + "px":"100%";
                            pData.data.forEach(
                               function( item ){
                                 i = i + 1;
                                 gaugeDiv = pRegionId + "_gauge" + i;
                                 var lUrl = item.url?item.url:'#';
                                 html = '<a href="' + lUrl + '">'
                                      + '<div class="a-JET-gauge-container" id="' + gaugeDiv + '" style="width:'+ w + ';height:' + pHeight + ';"></div>'
                                      + '<div id ="'+ gaugeDiv  +'_title" class="t-BadgeList-label t-BadgeList-label--bottom" "style="width:'+ w + ';"></div>'
                                      + '</a>' ;
                                 $("#" + pRegionId).append(html);
                                 $("#" + gaugeDiv + "_title").text(item.label.text);
                                 $("#" + gaugeDiv)
                                   .ojStatusMeterGauge({ "orientation"           : "circular",
                                                         "animationOnDisplay"    : "auto",
                                                         "animationOnDataChange" : "auto",
                                                         "value"                 : item.value,
                                                         "color"                 : item.color,
                                                         "class"                 : "a-JET-statusMeterGauge",
                                                         "tooltip"               : { "renderer" : function( dataContext){
                                                                                      var tooltip = document.createElement("div");
                                                                                      var tooltipText = document.createElement("span");
                                                                                      tooltipText.textContent = 
                                                                                        item.tooltip || item.label.text + " : " + item.metricLabel.text;
                                                                                                tooltip.appendChild( tooltipText );
                                                                                                return tooltip;
                                                                                               }
                                                                                    }
                                                      });
                            });
                    }
                });
            });
        },
        refresh: function (pRegionId, pHeight, pOrientation, pApexAjaxIdentifier) {
            init(pRegionId, pHeight, pOrientation, pApexAjaxIdentifier);
        }
    }
}(window.jet = window.jet || {}, apex.jQuery, apex.server, apex.util, apex.debug);