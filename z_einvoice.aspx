<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" >
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var xdate=[],ydate=[];
			
			$(document).ready(function() {
				q_getId();
				q_gf('', 'z_einvoice');
			});
			
			function q_gfPost() {
				//var a = '[{"date":"20170719"},{"date":"20170801"},{"date":"20170802"},{"date":"20170807"},{"date":"20170808"},{"date":"20170810"},{"date":"20170811"},{"date":"20170814"},{"date":"20170815"},{"date":"20170821"},{"date":"20170822"}]';
				//finish(JSON.parse(a));
				//return;
				getDate_SummaryResult();
				
			}
			
			function getDate_SummaryResult(){
				$.ajax({
                    url: "../einvoice/SummaryResult.aspx",
                    headers: { 'db': q_db },
                    type: 'POST',
                    //data: JSON.stringify(datea[0]),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                        if(data.length>0){
                        	xdate = JSON.parse(data);
                        }
                    },
                    complete: function(){
                    	finish();
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料寫入異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });
			}
			function getDate_ProcessResult(){
				$.ajax({
                    url: "../einvoice/ProcessResult.aspx",
                    headers: { 'db': q_db },
                    type: 'POST',
                    //data: JSON.stringify(datea[0]),
                    dataType: 'text',
                    timeout: 10000,
                    success: function(data){
                        if(data.length>0){
                        	ydate = JSON.parse(data);
                        }
                    },
                    complete: function(){ 
                    	finish();
                    },
                    error: function(jqXHR, exception) {
                        var errmsg = this.url+'資料寫入異常。\n';
                        if (jqXHR.status === 0) {
                            alert(errmsg+'Not connect.\n Verify Network.');
                        } else if (jqXHR.status == 404) {
                            alert(errmsg+'Requested page not found. [404]');
                        } else if (jqXHR.status == 500) {
                            alert(errmsg+'Internal Server Error [500].');
                        } else if (exception === 'parsererror') {
                            alert(errmsg+'Requested JSON parse failed.');
                        } else if (exception === 'timeout') {
                            alert(errmsg+'Time out error.');
                        } else if (exception === 'abort') {
                            alert(errmsg+'Ajax request aborted.');
                        } else {
                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
                        }
                    }
                });
				
			}
			
			function finish(){
				$('#q_report').q_report({
					fileName : 'z_einvoice',
					options : [{
						type : '0', //[1]
						name : 'path',
						value : location.protocol + '//' +location.hostname + location.pathname.toLowerCase().replace('z_einvoice.aspx','')
					},{
						type : '0', //[2]
						name : 'db',
						value : q_db
					}, {
						type : '6', //[3]    1
						name : 'xdate'
					}, {
						type : '6', //[4]    2
						name : 'ydate'
					}, {
						type : '1', //[5][6] 3
						name : 'zdate'
					}, {
						type : '6', //[7]    4    
						name : 'xinvoice'
					}, {
						type : '6', //[8]    5
						name : 'xvccbno'
					}]
				});
				q_popAssign();
				q_langShow();
				
				$('#txtZdate1').mask(r_picd);
				$('#txtZdate1').datepicker();
				$('#txtZdate2').mask(r_picd);
				$('#txtZdate2').datepicker();
				
				for(var i=0;i<xdate.length;i++){
					$('#listXdate').append('<option value="'+xdate[i].date+'"></option>');
				}
				$('#txtXdate').attr("list","listXdate");
				
				for(var i=0;i<ydate.length;i++){
					$('#listYdate').append('<option value="'+ydate[i].date+'"></option>');
				}
				$('#txtYdate').attr("list","listYdate");
				
				/*var t_para = new Array();
	            try{
	            	t_para = JSON.parse(q_getId()[3]);
	            }catch(e){
	            }    
	            if(t_para.length==0 || t_para.noa==undefined){
	            }else{
	            	$('#txtXnoa1').val(t_para.noa);
	            	$('#txtXnoa2').val(t_para.noa);
	            }*/
				$('#btnOk').before($('#btnOk').clone().attr('id', 'btnOk2').show()).hide();
				$('#btnOk2').click(function() {
					switch($('#q_report').data('info').radioIndex) {
						case 6:
							var bdate = $('#txtZdate1').val();
							var edate = $('#txtZdate2').val();
							var vccbno = $('#txtXvccbno').val();
							//匯入銷項發票
							$.ajax({
	                    url: "../einvoice/vfp2sql_vccb_rs.aspx?bdate="+bdate+"&edate="+edate+"&vccbno="+vccbno,
	                    headers: { 'db': q_db },
	                    type: 'POST',
	                    //data: JSON.stringify(datea[0]),
	                    dataType: 'text',
	                    timeout: 10000,
	                    success: function(data){
	                        console.log(data);
	                        alert(data);
	                    },
	                    complete: function(){ 
	                    	
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+'資料寫入異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
							break;
						case 4:
							var bdate = $('#txtZdate1').val();
							var edate = $('#txtZdate2').val();
							var invoice = $('#txtXinvoice').val();
							//匯入銷項發票
							$.ajax({
	                    url: "../einvoice/vfp2sql_vcca_rs.aspx?bdate="+bdate+"&edate="+edate+"&invoice="+invoice,
	                    headers: { 'db': q_db },
	                    type: 'POST',
	                    //data: JSON.stringify(datea[0]),
	                    dataType: 'text',
	                    timeout: 10000,
	                    success: function(data){
	                        console.log(data);
	                        alert(data);
	                    },
	                    complete: function(){ 
	                    	
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+'資料寫入異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
							break;
						case 2:
							//匯入客戶主檔
							$.ajax({
	                    url: "../einvoice/vfp2sql_cust_rs.aspx",
	                    headers: { 'db': q_db },
	                    type: 'POST',
	                    //data: JSON.stringify(datea[0]),
	                    dataType: 'text',
	                    timeout: 10000,
	                    success: function(data){
	                        console.log(data);
	                        alert(data);
	                    },
	                    complete: function(){ 
	                    	
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+'資料寫入異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
							break;
                        case 0:
                        	$('#result').show();
                        	$.ajax({
	                    url: "../einvoice/SummaryResult.aspx?date="+$('#txtXdate').val(),
	                    headers: { 'db': q_db },
	                    type: 'POST',
	                    //data: JSON.stringify(datea[0]),
	                    dataType: 'text',
	                    timeout: 10000,
	                    success: function(data){
	                        if(data.length>0){
	                        	//rdate = JSON.parse(data);
	                        	console.log(JSON.parse(data));
	                        	var result = JSON.parse(data);
	                        	
	                        	var errTable = "";
	                        	
	                        	var t_good=0,t_failed=0,t_total=0;
	                        	var n=1;
	                        	for(var i=0; i<result.length;i++){
	                        		for(var j=0;j<result[i].summaryResult.DetailList.Message.length;j++){
	                        			t_good += parseInt(result[i].summaryResult.DetailList.Message[j].ResultType.Good.ResultDetailType.Count);
	                        			t_failed += parseInt(result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Count);
	                        			t_total += parseInt(result[i].summaryResult.DetailList.Message[j].ResultType.Total.ResultDetailType.Count);
	                        			if(result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Count!="0"){
	                        				for(k=0;k<result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices.length;k++){
	                        					errTable += '<tr>';
	                        					errTable += '<td style="text-align:center">'+ "<a href=\"JavaScript:q_box('vcca.aspx',' ;noa=\\'"+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].ReferenceNumber+"\\' and 1=1;106','95%','95%','106')\">"+ (n++) +'</a></td>';
	                        					errTable += '<td style="text-align:center">'+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].ReferenceNumber+'</td>';	
	                        					errTable += '<td style="text-align:center">'+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].InvoiceDate+'</td>';	
	                        					errTable += '<td style="text-align:center">'+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].ERRCODE+'</td>';	
	                        					/*errTable += '<td>'
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].INFORMATION1
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].INFORMATION2
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].INFORMATION3
	                        						+'</td>';	*/
	                        					errTable += '<td>'
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE1
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE2
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE3
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE4
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE5
	                        						+result[i].summaryResult.DetailList.Message[j].ResultType.Failed.ResultDetailType.Invoices[k].MESSAGE6
	                        						+'</td>';
                        						errTable += '</tr>';	
	                        				}
	                        				
	                        			}
	                        		}
	                        	}
	                        	//result[0].summaryResult.DetailList.Message[0].ResultType.Failed.ResultDetailType.Invoices[0].ReferenceNumber
	                        	$('#result').empty();
	                        	$('#result').append('<table id="SummaryResult" border="1"></table>');
	                        	$('#SummaryResult').append("<tr><th style='width:80px;'>成功</th><th style='width:80px;'>失敗</th><th style='width:80px;'>總計</th></tr>");
	                        	$('#SummaryResult').append("<tr><td style='text-align:right'>"+t_good+"</td><td style='text-align:right'>"+t_failed+"</td><th style='text-align:right'>"+t_total+"</td></tr>");
	                        	if(errTable.length>0){
                        			$('#result').append('<table id="Failed" border="1" style="width:1500px;"></table>');
	                        		$('#Failed').append("<tr style='width:50px;'><th></th style='width:120px;'><th>發票號碼</th><th style='width:100px;'>日期</th><th style='width:70px;'>錯誤代碼</th><th style='width:1000px;'>資訊</th></tr>");
	                        		$('#Failed').append(errTable);
	                        	}
	                        
	                        }else{
	                        	console.log("no data");
	                        }
	                    },
	                    complete: function(){ 
	                    	
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+'資料寫入異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
                        break;
                  		default:
                  			$('#result').hide();
                  			$('#btnOk').click();
                  			break;
                  	}
					
				});
			}

			function q_getPrintPost(){
				var t_noa = $.trim($('#txtXnoa').val());
				if(t_noa.length > 0){
					$('#btnOk').click();
				}
			}

			function q_boxClose(s2) {
			}

			function q_gtPost(s2) {
			}
			
		</script>
	</head>
	<style type="text/css">
	</style>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<div id="q_menu"> </div>
		<div style="position: absolute;top: 10px;left:50px;z-index: 1;width:2000px;">
			<div id="container">
				<div id="q_report"> </div>
			</div>
			<div class="prt" style="margin-left: -40px;">
				<!--#include file="../inc/print_ctrl.inc"-->
			</div>
			<div id="result">
			
			</div>
		</div>
		
		<datalist id="listXdate"> </datalist>
		<datalist id="listYdate"> </datalist>
	</body>
</html>