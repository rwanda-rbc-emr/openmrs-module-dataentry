function showCalendar(obj) {
	makeCalendar(obj);
	if(self.gfPop)
		gfPop.fPopCalendar(obj);
	return false;
}

function makeCalendar(obj) {

	// turn off auto complete on inputs using this calendar
	if (document.getElementsByTagName) {
		var inputs = document.getElementsByTagName("input");
		for (var i=0;i<inputs.length; i++) {
			if (inputs[i].onclick &&
				inputs[i].onclick.toString().indexOf("showCalendar") != -1) {
					inputs[i].setAttribute("autocomplete", "off");
			}
		}
	}

	// make the iframe to contain the calendar
	var id = "gToday:normal.jsp";
	if (document.getElementById(id) == null) {
		var iframe = document.createElement("iframe");
		iframe.width=174;
		iframe.height=189;
		iframe.name=id;	// also defined in ipopeng.jsp as an IE hack.
		iframe.id = id;
		iframe.src= openmrsContextPath + '/scripts/calendar/ipopeng.html';
		iframe.scrolling='no';
		iframe.frameBorder='0';
		iframe.style.visibility = 'visible';
		iframe.style.position='absolute';
		iframe.style.zIndex='2000';
		iframe.style.top='-500px';
		iframe.style.left= '-500px';
		var bodies = document.getElementsByTagName("body");
		//var bodies = document.getElementById("stop-modal-content");
		var body = bodies[0];
		iframe.name = id;
		body.appendChild(iframe);
	}
}

if (addEvent) {
	addEvent(window, "load", makeCalendar);
}
else {
	makeCalendar();
}

/** a function which helps in validation to avoid that user input a future date **/
function CompareDates(dateFormat)
{
	var dt1 = null;
    var mon1 = null;
    var yr1 = null;
    var str2 = null;
    
	var str1 = document.getElementById("encDateId").value;
    var now  = new Date();
    var nowDay = now.getDate().toString().length == 1 ? '0'+now.getDate() : now.getDate();
    var month = now.getMonth()+1;
    var nowMonth = month.toString().length == 1 ? '0' + month : month;
    var nowYear = now.getYear()+1900;
    
    //var str2 = nowDay + "/" + nowMonth + "/" + nowYear;
    
    //alert("str1: -" + str1 + "- str2: -" + str2 + "-");
    
    
	if(dateFormat=='dd/mm/yyyy' || dateFormat=='jj/mm/aaaa') { 
		str2 = nowDay + "/" + nowMonth + "/" + nowYear;
	    dt1  = parseInt(str1.substring(0,2),10);
	    mon1 = parseInt(str1.substring(3,5),10);
	    yr1  = parseInt(str1.substring(6,10),10);
	    dt2  = parseInt(nowDay);
	    mon2 = parseInt(nowMonth);
	    yr2  = parseInt(nowYear);
	} else if(dateFormat=='mm/dd/yyyy' || dateFormat=='mm/jj/aaaa') {
		str2 = nowMonth + "/" + nowDay + "/" +  nowYear;
		mon1  = parseInt(str1.substring(0,2),10);
	    dt1 = parseInt(str1.substring(3,5),10);
	    yr1  = parseInt(str1.substring(6,10),10);
	    mon2  = parseInt(nowMonth);
	    dt2 = parseInt(nowDay);
	    yr2  = parseInt(nowYear);
	} else{
		alert("Invalid date : "+dateFormat+": not supported !");
		$("#encDateId").val("");
		return;
	}
	var month1 = mon1 - 1;
	var month2 = mon2 - 1;
    var date1 = new Date(yr1, mon1, dt1);
    var date2 = new Date(nowYear, nowMonth, nowDay);
    if(date2 < date1)
    {
    	 $("#msgId").html("The date can't be in future");
    	 $("#msgId").addClass("error");
    	 $("#encDateId").val("");    	 
    }
    else
    {
    	$("#msgId").html("");
   	 	$("#msgId").removeClass("error");
    }
} 
