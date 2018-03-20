<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
    	//電子發票證明聯
        public class ParaIn
        {
            public string bno="", eno="",bdate="",edate="";
        }

        public class Invoice
        {
            public string noa;
            public Item[] item;
        }
        
        public class Item
        {
            public string accy, noa, noq;
            public string datea,invono,cust,serial,addr,product;
            public float mount,price,total,total2,total3,total4;
            public string memo;
            public float t_total;
            public string comp, comp_serial, comp_addr,taxtype;
       }

        public void drawLine(iTextSharp.text.pdf.PdfContentByte cb)
        {
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.SetColorStroke(iTextSharp.text.BaseColor.BLACK);
            cb.SetLineWidth(1);
            cb.MoveTo(25, 295);//外框線
            cb.LineTo(503, 295);
            cb.LineTo(503, 20);
            cb.LineTo(25, 20);
            cb.LineTo(25, 295);

            cb.MoveTo(25, 275);//內框線(橫上)
            cb.LineTo(503, 275);

            cb.MoveTo(150, 295);//內框線(直)
            cb.LineTo(150, 175);
            cb.MoveTo(225, 295);
            cb.LineTo(225, 175);
            cb.MoveTo(300, 295);
            cb.LineTo(300, 70);
            cb.MoveTo(375, 295);
            cb.LineTo(375, 20);

            cb.MoveTo(70, 150);
            cb.LineTo(70, 95);

            cb.MoveTo(109, 150);
            cb.LineTo(109, 95);

            cb.MoveTo(148, 150);
            cb.LineTo(148, 95);

            cb.MoveTo(187, 150);
            cb.LineTo(187, 95);

            cb.MoveTo(226, 150);
            cb.LineTo(226, 95);

            cb.MoveTo(265, 150);
            cb.LineTo(265, 95);

            cb.MoveTo(25, 175);//內框線(橫下)
            cb.LineTo(503, 175);
            cb.MoveTo(25, 150);
            cb.LineTo(503, 150);

            cb.MoveTo(25, 95);
            cb.LineTo(375, 95);

            cb.MoveTo(25, 70);
            cb.LineTo(375, 70);
            cb.Stroke();
        }
        public void inputTitle(iTextSharp.text.pdf.PdfContentByte cb ,Item[] item,int page)
        {
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 14);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "電子發票證明聯", 210, 425, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).datea, 225, 405, 0);
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "發票號碼:" + ((Item)item[0]).invono, 25, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "格    式:25", 450, 380, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "買方:" + ((Item)item[0]).cust, 25, 355, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號:" + ((Item)item[0]).serial, 25, 330, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Item)item[0]).addr, 25, 305, 0);
            if (item.Length <= 6)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第1頁/共1頁", 503, 305, 0);
            else if (item.Length > 6 && item.Length % 6 != 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + ((item.Length / 6) + 1) + "頁", 503, 305, 0);
            else if (item.Length > 6 && item.Length % 6 == 0)
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "第" + page + "頁/" + "共" + (item.Length / 6) + "頁", 503, 305, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "品名", 75, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "數量", 175, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "金額", 325, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "單價", 250, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "備註", 425, 280, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "銷售量合計", 30, 158, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total2.ToString(), 370, 160, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業稅", 31, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "應稅", 80, 120, 0);
            if (((Item)item[0]).taxtype == "1")
				cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 125, 120, 0);
            else if (((Item)item[0]).taxtype == "2")
				cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 200, 120, 0);
            else if (((Item)item[0]).taxtype == "4")
				cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "√", 275, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "零稅率", 153, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "免稅", 236, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total3.ToString(), 370, 120, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計", 30, 80, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)item[0]).total4.ToString(), 370, 80, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業人蓋統一發票專用章", 385, 160, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計新台幣(中文大寫)", 30, 42, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ConvertInt(((Item)item[0]).total4.ToString()), 370, 42, 0);
            if (((Item)item[0]).comp.Length > 10)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方:" + ((Item)item[0]).comp.Substring(0, 10), 378, 138, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).comp.Substring(10, ((Item)item[0]).comp.Length - 10), 378, 128, 0);
            }
            else
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方:" + ((Item)item[0]).comp, 378, 138, 0);
            }
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號:" + ((Item)item[0]).comp_serial, 378, 115, 0);
            if (((Item)item[0]).comp_addr.Length > 10)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Item)item[0]).comp_addr.Substring(0, 10), 378, 90, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)item[0]).comp_addr.Substring(10, ((Item)item[0]).comp_addr.Length - 10), 378, 80, 0);
            }
            else
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址:" + ((Item)item[0]).comp_addr, 378, 90, 0);
            }
            cb.EndText();
        }
        
		private static string[] cstr = { "零", "壹", "貳", "叁", "肆", "伍", "陸", "柒", "捌", "玖" };
        private static string[] wstr = { "", "", "拾", "佰", "仟", "萬", "拾", "佰", "仟", "億", "拾", "佰", "仟" };
        public string ConvertInt(string str)
        {
            int len = str.Length;

            int i;

            string tmpstr, rstr;

            rstr = "";

            for (i = 1; i <= len; i++)
            {

                tmpstr = str.Substring(len - i, 1);

                rstr = string.Concat(cstr[Int32.Parse(tmpstr)] + wstr[i], rstr);

            }

            rstr = rstr.Replace("拾零", "拾");

            rstr = rstr.Replace("零拾", "零");

            rstr = rstr.Replace("零佰", "零");

            rstr = rstr.Replace("零仟", "零");

            rstr = rstr.Replace("零萬", "萬");

            for (i = 1; i <= 6; i++)

            rstr = rstr.Replace("零零", "零");

            rstr = rstr.Replace("零萬", "零");

            rstr = rstr.Replace("零億", "億");

            rstr = rstr.Replace("零零", "零");

            rstr += "元整";
            
            return rstr;
        }
		
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
        	string db = "st";
        	if(Request.QueryString["db"] !=null && Request.QueryString["db"].Length>0)
        	db= Request.QueryString["db"];
        	connectionString = "Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database="+db;

			var item = new ParaIn();
            if (Request.QueryString["bno"] != null && Request.QueryString["bno"].Length > 0)
            {
                item.bno = Request.QueryString["bno"];
            }
            if (Request.QueryString["eno"] != null && Request.QueryString["eno"].Length > 0)
            {
                item.eno = Request.QueryString["eno"];
            }
            if (Request.QueryString["bdate"] != null && Request.QueryString["bdate"].Length > 0)
            {
                item.bdate = Request.QueryString["bdate"];
            }
            if (Request.QueryString["edate"] != null && Request.QueryString["edate"].Length > 0)
            {
                item.edate = Request.QueryString["edate"];
            }
            //資料
            System.Data.DataSet ds = new System.Data.DataSet();
            
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connectionString))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string queryString = @"
		        set @t_eno = case when len(@t_eno)=0 then char(255) else @t_eno end
                set @t_edate = case when len(@t_edate)=0 then char(255) else @t_edate end
declare @tmpa table(
	noa nvarchar(20)
	,n int
)
declare @tmpb table(
    noa nvarchar(20),
    noq nvarchar(10),
	datea nvarchar(30),
	
	invono nvarchar(50),
	cust nvarchar(max),
	serial nvarchar(50),
	addr nvarchar(max),
	product nvarchar(max),
	mount float,
	price float, --單價
	total float, --金額
	memo nvarchar(max),
	
	total2 float,
	total3 float,
	total4 float,
	
	comp nvarchar(max),
	comp_serial nvarchar(50),
	comp_addr nvarchar(max),
	taxtype nvarchar(10)
)
insert into @tmpb(noa,noq,datea,invono,cust,serial,addr,product,mount,price,total,memo,comp,comp_serial,comp_addr,total3,taxtype,total4)
select top 50 b.noa,b.noq,a.datea,a.noa,a.comp,a.serial,c.addr_comp,b.product,b.mount,b.price,b.money,a.memo,e.acomp,e.serial,e.addr,a.tax,a.taxtype,a.money
from vcca a
left join vccas b on a.noa = b.noa
left join cust c on a.custno = c.noa
left join acomp e on a.cno = e.noa
where a.noa between @t_bno and @t_eno
and a.datea between @t_bdate and @t_edate
order by a.noa,b.noq

insert into @tmpa(noa,n)select noa,count(1) from @tmpb group by noa order by noa

update @tmpb set total2 = b.total
from @tmpb a
outer apply (select SUM(total) as total,noa from @tmpb where noa=a.noa group by noa)b
update @tmpb set datea = convert(nvarchar,dbo.ChineseEraName2AD(datea),120)
select * from @tmpa
select * from @tmpb";
				
                System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(queryString, connSource);
                cmd.Parameters.AddWithValue("@t_bno", item.bno);
                cmd.Parameters.AddWithValue("@t_eno", item.eno);
                cmd.Parameters.AddWithValue("@t_bdate", item.bdate);
                cmd.Parameters.AddWithValue("@t_edate", item.edate);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }
            Invoice[] invoice = new Invoice[ds.Tables[0].Rows.Count];

            for (int i = 0; i < invoice.Length; i++)
            {
                invoice[i] = new Invoice();
                invoice[i].noa = System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[0]) ? "" : (System.String)ds.Tables[0].Rows[i].ItemArray[0];
                invoice[i].item = new Item[System.DBNull.Value.Equals(ds.Tables[0].Rows[i].ItemArray[1]) ? 0 : (System.Int32)ds.Tables[0].Rows[i].ItemArray[1]];
                int n = 0;
                for(int j=0;j<ds.Tables[1].Rows.Count;j++){
                    if(invoice[i].noa == (System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0])){
                        invoice[i].item[n] = new Item();        
                       
                        invoice[i].item[n].noa = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[0]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[0];
                        invoice[i].item[n].noq = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[1]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[1];
                        invoice[i].item[n].datea = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[2]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[2];
                        invoice[i].item[n].invono = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[3]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[3];
                        invoice[i].item[n].cust = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[4]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[4];
                        invoice[i].item[n].serial = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[5]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[5];
                        invoice[i].item[n].addr = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[6]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[6];
                        invoice[i].item[n].product = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[7]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[7];
                        invoice[i].item[n].mount = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[8]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[8];
                        invoice[i].item[n].price = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[9]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[9];
                        invoice[i].item[n].total = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[10]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[10];
                        invoice[i].item[n].memo = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[11]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[11];
                        invoice[i].item[n].total2 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[12]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[12];
                        invoice[i].item[n].total3 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[13]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[13];
                        invoice[i].item[n].total4 = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[14]) ? 0 : (float)(System.Double)ds.Tables[1].Rows[j].ItemArray[14];
                        invoice[i].item[n].comp = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[15]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[15];
                        invoice[i].item[n].comp_serial = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[16]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[16];
                        invoice[i].item[n].comp_addr = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[17]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[17];
				        invoice[i].item[n].taxtype = System.DBNull.Value.Equals(ds.Tables[1].Rows[j].ItemArray[18]) ? "" : (System.String)ds.Tables[1].Rows[j].ItemArray[18];
                        n++;
                    }  
                }
            }
            
            
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(525, 450), 0, 0, 0, 0);
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese,bold;
            if(Environment.OSVersion.Version.Major>6){
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
           		bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }else{
            	bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            	bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            if (invoice.Length == 0)
            {
                cb.SetColorFill(iTextSharp.text.BaseColor.RED);
                cb.BeginText();
                cb.SetFontAndSize(bfChinese, 30);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "無資料", 20, 20, 0);
                cb.EndText();
            }
            else
            {
                for (int j = 0; j < invoice.Length; j++)
                {
                    if(j>0)
                        doc1.NewPage();
                    for (int i = 0, y = 260, page = 1; i < invoice[j].item.Length; i++, y -= 15)
                    {
                        if (i == 0)
                        {
                            drawLine(cb);
                            inputTitle(cb, invoice[j].item, page);
                        }
                        if (i >= 6 && i % 6 == 0)
                        {
                            doc1.NewPage();
                            page++;
                            y = 260;
                            drawLine(cb);
                            inputTitle(cb, invoice[j].item, page);
                        }
                        //TEXT
                        cb.BeginText();
                        cb.SetFontAndSize(bfChinese, 10);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)invoice[j].item[i]).product, 30, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).mount.ToString(), 210, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).price.ToString(), 290, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, ((Item)invoice[j].item[i]).total.ToString(), 370, y, 0);
                        cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, ((Item)invoice[j].item[i]).memo, 380, y, 0);
                        cb.EndText();
                    }
                }
                    
            }
            doc1.Close();
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename=EinvoiceA5.pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }
    </script>