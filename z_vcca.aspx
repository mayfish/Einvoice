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
            aPop = new Array(['txtXcno', 'lblXcno', 'acomp', 'noa,acomp', 'txtXcno,txtXacomp', 'acomp_b.aspx']);
            t_cno = '';
            t_isinit = false;
            var z_cno=r_cno,z_acomp=r_comp,t_invoicetype='';
            $(document).ready(function() {
                q_getId();
                q_gt('acomp', 'stop=1 ', 0, 0, 0);
                
                
                
            });
            
            function q_gfPost() {
                LoadFinish();
                
            }
			
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'acomp':
                        var as = _q_appendData("acomp", "", true);
                       if (as[0] != undefined) {
	                		z_cno=as[0].noa;
	                		z_acomp=as[0].acomp;
	                	}
                        q_gt('invoicetype', '', 0, 0, 0, "getInvoicetype", r_accy);
                        break;
                	case 'getInvoicetype':
                		var as = _q_appendData("invoicetype", "", true);
                		if (as[0] != undefined){
                			t_invoicetype = '';
                			for(var i=0;i<as.length;i++){
                				t_invoicetype += (t_invoicetype.length>0?',':'') + as[i].noa+'@'+as[i].namea;
                			}
                		}
                		q_gf('', 'z_vcca');
                		break;
                }
            }

            function LoadFinish() {
                $('#q_report').q_report({
                    fileName : 'z_vcca',
                    options : [{/*0 [1]*/
                        type : '0',
                        name : 'accy',
                        value : r_accy
                    },{/*0 [2]*/
                        type : '0',
                        name : 'xworker',
                        value : r_name
                    }, {/*1 [3][4]*/
                        type : '1',
                        name : 'xmon'
                    }, {/*2 [5][6]*/
                        type : '1',
                        name : 'xdate'
                    }, {/*3 [7][8]*/
                        type : '2',
                        name : 'xcust',
                        dbf : 'cust',
                        index : 'noa,comp',
                        src : 'cust_b.aspx'
                    }, {/*4 [9][10]*/
                        type : '2',
                        name : 'xproduct',
                        dbf : 'ucca',
                        index : 'noa,product',
                        src : 'ucca_b.aspx'
                    }, {/*5 [11]*/
                        type : '5',
                        name : 'xtype',
                        value : [q_getPara('report.all')].concat(t_invoicetype.split(','))
                    }, {/*6 [12]*/
                        type : '6',
                        name : 'xcno'
                    }, {/*7 [13][14]*/
                        type : '2',
                        name : 'xtgg',
                        dbf : 'tgg',
                        index : 'noa,comp',
                        src : 'tgg_b.aspx'
                    }, {/*8 [15]*/
						type : '5',
						name : 'vccbtypea', 
						value : [q_getPara('report.all')].concat(q_getPara('vccb.typea').split(','))
					}, {/*9 [16]*/
                        type : '6',
                        name : 'xbinvono'
                    }, {/*10 [17]*/
                        type : '6',
                        name : 'xeinvono'
                    }, {/*11 [18] proj=SB用*/
                        type : '5',
                        name : 'sbtype',
                        value : ['#non@全部','1@直銷','2@代銷']
                    },{/*0 [19]*/
                        type : '0',
                        name : 'xrlen',
                        value : r_len
                    },{/*0 [20]*/
                        type : '0',
                        name : 'xproject',
                        value : q_getPara('sys.project').toUpperCase()
                    }, {/*12 [21] */
                        type : '8',
                        name : 'xoption',
                        value : ['01@只顯示作廢發票','02@只顯示異常']
                    }]
                });
                
                q_popAssign();
                q_getFormat();
                q_langShow();
                
                $('#q_report').click(function(e) {
	            	if(q_getPara('sys.project').toUpperCase()!='SB')
	                	$('#Sbtype').hide();
	            });
	            
                var r_1911=1911;
				if(r_len==4){//西元年
					r_1911=0;
				}else{
					$('#txtXdate1').datepicker();
					$('#txtXdate2').datepicker();
				}
                
                $('#txtXmon1').mask(r_picm);
                $('#txtXmon2').mask(r_picm);
                $('#txtXdate1').mask(r_picd);
                $('#txtXdate2').mask(r_picd);
                
                $('#txtXdate1').val(q_date().substr(0,r_len)+'/01/01');
                $('#txtXdate2').val(q_date().substr(0,r_len)+'/12/31');
                $('#txtXmon1').val(q_date().substr(0,r_lenm));
                $('#txtXmon2').val(q_date().substr(0,r_lenm));
                
                $('#Xcno').css("width","300px");
                $('#txtXcno').css("width","90px");
                
                var tmp = document.getElementById("txtXcno");
                var t_input = document.createElement("input");
                t_input.id='txtXacomp';
                t_input.type='text';
                t_input.className = "c2 text";
                t_input.disabled='disabled';
                tmp.parentNode.appendChild(t_input,tmp);
                aPop.push(['txtXcno','lblXcno','acomp','noa,acomp','txtXcno,txtXacomp','acomp_b.aspx']);
                 
                $('#txtXcno').val(z_cno);
                $('#txtXacomp').val(z_acomp);
                
                if(q_getPara('sys.project').toUpperCase()!='SB')
	                $('#Sbtype').hide();
                
                /*$("input[type='checkbox'][value='checkAll']").click(function() {
                    if ($(this).next('span').text() == '全選') {
                        $("input[type='checkbox'][value!='']").attr('checked', true);
                        $(this).removeAttr('checked');
                        $(this).next('span').text('取消全選');
                    } else if ($(this).next('span').text() == '取消全選') {
                        $("input[type='checkbox'][value!='']").removeAttr('checked');
                        $(this).next('span').text('全選');
                    }
                });*/
            }

            function q_boxClose(s2) {
            }

		</script>
	</head>
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
		</div>
	</body>
</html>