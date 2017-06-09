<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">
            q_tables = 's';
            var q_name = "bonus";
            var q_readonly = ['txtNoa','txtWorker','txtWorker2','txtQtime'];
            var q_readonlys = [];
            var bbmNum = [];
            var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwCount2 = 13;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'datea';

            aPop = new Array();
           
            $(document).ready(function() {
                q_desc = 1;
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt(q_name, q_content, q_sqlCount, 1, 0, '', r_accy);
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);
            }

            function sum() {
                for (var i = 0; i < q_bbsCount; j++) {
                }
            }

            function mainPost() {
                q_getFormat();
                bbmMask = [['txtDatea', r_picd]];
                q_mask(bbmMask);
               
               	var prizetype ='A@特別獎-1000 萬元,B@無實體2000元,C@無實體百萬元,0@特獎-200萬元,1@頭獎-20萬元,2@二獎-4萬元,3@三獎-1萬元,4@四獎-4000元,5@五獎-1000元,6@六獎-200元';

				q_cmbParse("cmbPrizetype", prizetype, "s");
               
				$('#btnImport').click(function(e){
					var files = $('#btnFile')[0].files;
					if(files.length<=0){
						alert('請選擇檔案');
						return;
					}
					var fr = new FileReader();
					fr.readAsDataURL(files[0]);
					fr.onload = function(e){
						$.ajax({
		                    url: 'bonus.ashx',
		                    headers: { 'database': q_db },
		                    type: 'POST',
		                    data: fr.result,
		                    dataType: 'text',
		                    timeout: 10000,
		                    success: function(data){
		                        consol.log(data);
		                    },
		                    complete: function(){ 
		                    	Unlock(1);
		                    },
		                    error: function(jqXHR, exception) {
		                        var errmsg = this.url+'異常。\n';
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
						
						
						/*oReq.timeout = 360000;
						oReq.ontimeout = function () { $('#msg').text("Timed out!!!");};
						oReq.open("POST", 'upload_wh.aspx', true);
						oReq.setRequestHeader("Content-type", "text/plain");
                        oReq.setRequestHeader("filename", fr.filename);
                        oReq.setRequestHeader("noa", fr.noa);
                        oReq.setRequestHeader("noq", fr.noq);
						oReq.send(fr.result);*/
					};
					
				});               
            }

            
            function q_boxClose(s2) {
				switch (b_pop) {
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}

            function q_gtPost(t_name) {
                var as;
                switch (t_name) {
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                     default:
                     	break;
                }
            }

            function btnOk() {
            	if($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())){
					alert('日期異常。');
            		return;
				}
				if (q_cur == 1)
                    $('#txtWorker').val(r_name);
                else
                    $('#txtWorker2').val(r_name);
                var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
				if (t_noa.length == 0 || t_noa == "AUTO")
					q_gtnoa(q_name, replaceAll(q_getPara('sys.key_bonus') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
				else
					wrServer(t_noa);
            }
            
            function q_funcPost(t_func, result) {
                switch(t_func) {
                    default:
                    	break;
                }
            }
            
            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('bonus_s.aspx', q_name + '_s', "500px", "600px", q_getMsg("popSeek"));
            }
            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                    $('#lblNo_' + i).text(i + 1);
                    if ($('#btnMinus_' + i).hasClass('isAssign')) 
                    	continue;
                    $('#txtX_' + i).bind('contextmenu', function(e) {
                        /*滑鼠右鍵*/
                        e.preventDefault();
                        var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
                        $('#btnX_' + n).click();
                    });
                }
                _bbsAssign();
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('');//一定要空白  //r_userno+(new Date()).getTime()
                $('#txtDatea').val(q_date());
                $('#txtDatea').focus();
            }
			var guid = (function() {
				function s4() {return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);}
				return function() {return s4() + s4() + '-' + s4() + '-' + s4() + '-' +s4() + '-' + s4() + s4() + s4();};
			})();
			
            function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#txtDatea').focus();
			}

            function btnPrint() {
                q_box("z_bonus.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({
                    noa : trim($('#txtNoa').val())
                }) + ";" + r_accy + "_" + r_cno, 'bonus', "95%", "95%", m_print);
            }

            function wrServer(key_value) {
                var i;
                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['invoicenumber']) {
                    as[bbsKey[1]] = '';
                    return;
                }

                q_nowf();
                return true;
            }

            function q_stPost() {
                if (q_cur == 1 || q_cur == 2) {
                }
            }

            function refresh(recno) {
                _refresh(recno);
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                if (t_para) {
                    $('#btnFile').attr('disabled','disabled');
                } else {
                    $('#btnFile').removeAttr('disabled');
                }
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
            }

            function q_appendData(t_Table) {
                dataErr = !_q_appendData(t_Table);
            }

            function btnSeek() {
                _btnSeek();
            }

            function btnTop() {
                _btnTop();
            }

            function btnPrev() {
                _btnPrev();
            }

            function btnPrevPage() {
                _btnPrevPage();
            }

            function btnNext() {
                _btnNext();
            }

            function btnNextPage() {
                _btnNextPage();
            }

            function btnBott() {
                _btnBott();
            }

            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }

            function btnDele() {
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
            }

            function q_popPost(s1) {
                switch (s1) {
                    default:
                        break;
                }
            }

            function FormatNumber(n) {
                var xx = "";
                if (n < 0) {
                    n = Math.abs(n);
                    xx = "-";
                }
                n += "";
                var arr = n.split(".");
                var re = /(\d{1,3})(?=(\d{3})+$)/g;
                return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
            }

		</script>
		<style type="text/css">
            #dmain {
				overflow: auto;
				width: 1200px;
			}
			.dview {
				float: left;
				width: 500px;
				border-width: 0px;
			}
			.tview {
				border: 5px solid gray;
				font-size: medium;
				background-color: black;
			}
			.tview tr {
				height: 30px;
			}
			.tview td {
				padding: 2px;
				text-align: center;
				border-width: 0px;
				background-color: #FFFF66;
				color: blue;
			}
			.dbbm {
				float: left;
				width: 700px;
				/*margin: -1px;
				 border: 1px black solid;*/
				border-radius: 5px;
			}
			.tbbm {
				padding: 0px;
				border: 1px white double;
				border-spacing: 0;
				border-collapse: collapse;
				font-size: medium;
				color: blue;
				background: #cad3ff;
				width: 100%;
			}
			.tbbm tr {
				height: 35px;
			}
			.tbbm tr td {
				width: 16%;
			}
			.tbbm .tr2, .tbbm .tr3, .tbbm .tr4 {
				background-color: #FFEC8B;
			}
			.tbbm .tdZ {
				width: 1%;
			}
			.tbbm tr td span {
				float: right;
				display: block;
				width: 5px;
				height: 10px;
			}
			.tbbm tr td .lbl {
				float: right;
				color: blue;
				font-size: medium;
			}
			.tbbm tr td .lbl.btn {
				color: #4297D7;
				font-weight: bolder;
			}
			.tbbm tr td .lbl.btn:hover {
				color: #FF8F19;
			}
			.txt.c1 {
				width: 100%;
				float: left;
			}
			.txt.num {
				text-align: right;
			}
			.tbbm td {
				margin: 0 -1px;
				padding: 0;
			}
			.tbbm td input[type="text"] {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
				float: left;
			}
			.tbbm select {
				border-width: 1px;
				padding: 0px;
				margin: -1px;
			}
			.tbbs a {
				font-size: medium;
			}
			input[type="text"], input[type="button"] {
				font-size: medium;
			}
			.num {
				text-align: right;
			}
			select {
				font-size: medium;
			}
		</style>
	</head>
	<body>
		<!--#include file="../inc/toolbar.inc"-->
		<div id="dmain">
			<div class="dview" id="dview" >
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:5%"><a id='vewChk'> </a></td>
						<td align="center" style="width:5%"><a id='vewType'> </a></td>
						<td align="center" style="width:25%"><a>發票所屬年月</a></td>
						<td align="center" style="width:25%"><a>總記錄數</a></td>
						<td align="center" style="width:40%"><a>總中獎獎金金額</a></td>
					</tr>
					<tr>
						<td>
						<input id="chkBrow.*" type="checkbox" style=''/>
						</td>
						<td align="center" id='typea=vcc.typea'>~typea=vcc.typea</td>
						<td align="center" id='invoiceyyymm'>~invoiceyyymm</td>
						<td align="center" id='totrecordcnt'>~totrecordcnt</td>
						<td align="center" id='totprizeamt'>~totprizeamt</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td> </td>
                        <td class="tdZ"> </td>
                    </tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblDatea' class="lbl">日期</a></td>
						<td><input id="txtDatea" type="text"  class="txt c1"/></td>
						<!--<td><input type="file" id="btnFile"/></td>
						<td><input type="button" id="btnImport" value="匯入中獎清冊"/></td>-->
					</tr>
					<tr>
						<td><span> </span><a id='lblMain' class="lbl">主檔代號</a></td>
						<td><input id="txtMain" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblTotrecordcnt' class="lbl">總記錄數</a></td>
						<td><input id="txtTotrecordcnt" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblTotprizeamt' class="lbl">總中獎<BR>獎金金額</a></td>
						<td><input id="txtTotprizeamt" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblInvoiceyyymm' class="lbl">發票所屬年月</a></td>
						<td><input id="txtInvoiceyyymm" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblRecawardbegin' class="lbl">領獎期間<BR>起始日期</a></td>
						<td><input id="txtRecawardbegin" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblRecawardend' class="lbl">領獎期間<BR>截止日期</a></td>
						<td><input id="txtRecawardend" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl">備註</a></td>
						<td colspan="5"><textarea id="txtMemo" cols="10" rows="5" style="width: 99%;height: 50px;"> </textarea></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblWorker" class="lbl">製表人</a></td>
						<td><input id="txtWorker" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblWorker2" class="lbl">修改者</a></td>
						<td><input id="txtWorker2" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblQtime" class="lbl">匯入日期</a></td>
						<td><input id="txtQtime" type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div style="width: 2500px;">
			<table>
				<tr style='color:white; background:#003366;' > 				
					<td align="center" colspan="1" rowspan="3" style="width:50px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" colspan="1" rowspan="3" style="width:50px;"><a style="font-weight: bold;text-align: center;display: block;width:95%;"> </a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>廠商總公司統一編號</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>發票所屬年月</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>發票號碼-字軌</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>發票號碼-號碼</a></td>
					<td align="center" colspan="6" rowspan="1"><a>消費者資訊</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>載具類別號碼</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>載具類別名稱</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>載具顯碼id</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>載具隱碼id</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>四位隨機碼</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>中獎獎別</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>中獎獎金</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>買受人-營利事業統一編號</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>大平台已匯款註記</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>資料類別</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>例外代碼</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>列印格式</a></td>
					<td align="center" colspan="1" rowspan="3" style="width:100px;"><a>唯一識別碼</a></td>
				</tr>
				<tr style='color:white; background:#003366;' > 	
					<!--  -->
					<!--  -->
					<!-- 廠商總公司統一編號 -->
					<!-- 發票所屬年月 -->
					<!-- 發票號碼-字軌 -->
					<!-- 發票號碼-號碼 -->
					<td align="center" colspan="1" rowspan="2" style="width:100px;"><a>賣方-營業人名稱</a></td>
					<td align="center" colspan="1" rowspan="2" style="width:100px;"><a>賣方-營業人統一編號</a></td>
					<td align="center" colspan="1" rowspan="2" style="width:100px;"><a>賣方-營業人地址</a></td>
					<td align="center" colspan="2" rowspan="1"><a>開立日期</a></td>
					<td align="center" colspan="1" rowspan="1"><a>發票金額</a></td>
					<!-- 載具類別號碼 -->
					<!-- 載具類別名稱 -->
					<!-- 載具顯碼id -->
					<!-- 載具隱碼id -->
					<!-- 四位隨機碼 -->
					<!-- 中獎獎別 -->
					<!-- 中獎獎金 -->
					<!-- 買受人-營利事業統一編號 -->
					<!-- 大平台已匯款註記 -->
					<!-- 資料類別 -->
					<!-- 例外代碼 -->
					<!-- 列印格式 -->
					<!-- 唯一識別碼 -->
				</tr>
				<tr style='color:white; background:#003366;' > 	
					<!--  -->
					<!--  -->
					<!-- 廠商總公司統一編號 -->
					<!-- 發票所屬年月 -->
					<!-- 發票號碼-字軌 -->
					<!-- 發票號碼-號碼 -->
					<!-- 賣方-營業人名稱 -->
					<!-- 賣方-營業人統一編號 -->
					<!-- 賣方-營業人地址 -->
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a>發票日期</a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a>發票時間</a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a>總計</a></td>
					<!-- 載具類別號碼 -->
					<!-- 載具類別名稱 -->
					<!-- 載具顯碼id -->
					<!-- 載具隱碼id -->
					<!-- 四位隨機碼 -->
					<!-- 中獎獎別 -->
					<!-- 中獎獎金 -->
					<!-- 買受人-營利事業統一編號 -->
					<!-- 大平台已匯款註記 -->
					<!-- 資料類別 -->
					<!-- 例外代碼 -->
					<!-- 列印格式 -->
					<!-- 唯一識別碼 -->
				</tr>
			</table>
		</div>
		<div class='dbbs' style="width: 2500px;">
			<table id="tbbs" class='tbbs'>
				<tr style="color:white; background:#003366;display:none;" >
					<td align="center" style="width:50px"> </td>
					<td align="center" style="width:50px;"> </td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
					<td align="center" colspan="1" rowspan="1" style="width:100px;"><a> </a></td>
				</tr>
				<tr class="data" style='background:#cad3ff;'>
					<td align="center" style="width:50px">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input type="text" id="txtNoq.*" style="display:none;"/>
					</td>
					<td style="width:50px"><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;width:95%;"> </a></td>
					<td style="width:100px;"><input type="text" id="txtTcompanyban.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtInvoiceyyymm.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtInvoiceaxle.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtInvoicenumber.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtName.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtBan.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtAddress.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtInvoicedate.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtInvoicetime.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtTotalamount.*" style="width:95%;text-align:right;"/></td>
					<td style="width:100px;"><input type="text" id="txtCarriertype.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtCarriername.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtCarrieridclear.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtCarrieridhide.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtRandomnumber.*" style="width:95%;"/></td>
					<td style="width:100px;"><select id="cmbPrizetype.*" style="width:95%;"> </select></td>
					<td style="width:100px;"><input type="text" id="txtPrizeamt.*" style="width:95%;text-align:right;"/></td>
					<td style="width:100px;"><input type="text" id="txtBban.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtDepositmk.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtDatatype.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtExceptioncode.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtPrintformat.*" style="width:95%;"/></td>
					<td style="width:100px;"><input type="text" id="txtUid.*" style="width:95%;"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>