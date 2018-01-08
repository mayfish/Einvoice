
<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        static string connString = @"Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=";
        //static string connStringTNK = @"Data Source=127.0.0.1,1798;Persist Security Info=True;User ID=sa;Password=1qaz2wsx;Database=TNK";

        public class Vccb
        {
            public string noa;
            public string serial;
            public string comp;
            public string addr;
            public string money;
            public string tax;
            public string total;
            public int n;
            public string nob;
            public string custno;
            public Vccbs[] bbs;
        }
        
        public class Vccbs
        {
            public string noa;
            public string noq;
            public string invocieType;
            public string yy;
            public string mm;
            public string dd;
            public string track;
            public string number;
            public string product;
            public string mount;
            public string price;
            public string money;
            public string tax;
            public bool isTax;
            public bool isZero;
            public bool isNone;
        }
       
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

            string db = "st", bvccbno = "", evccbno = "";
            if (Request.QueryString["db"] != null && Request.QueryString["db"].Length > 0)
                db = Request.QueryString["db"];
            if (Request.QueryString["bvccbno"] != null && Request.QueryString["bvccbno"].Length > 0)
                bvccbno = Request.QueryString["bvccbno"];
            if (Request.QueryString["evccbno"] != null && Request.QueryString["evccbno"].Length > 0)
                evccbno = Request.QueryString["evccbno"];
            //檢查是否有輸入參數
            if (bvccbno.Length == 0 || evccbno.Length == 0 || db.Length == 0)
            {
                Response.Write("請輸入參數：折讓單號(bvccbno,evccbno)、資料庫(db)");
                Response.End();
                return;
            }

            Vccb[] vccb = GetVccb(db,bvccbno,evccbno);
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4);
            //A4
            float width = doc1.PageSize.Width;   //  21cm
            float height = doc1.PageSize.Height;   //  29.7cm
            doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
            
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

            for (int i = 0; i < vccb.Length; i++)
            {
                doc1.NewPage();
                Template(ref cb, width, height, bfChinese);
                Content(ref cb, width, height, bfChinese, vccb[i]);
            }

            doc1.Close();
            
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename="+bvccbno+".pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }

        public Vccb[] GetVccb(string db,string bvccbno,string evccbno)
        {
            System.Data.DataSet ds = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connString+db))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string query = @"
            declare @bbm table(
	noa nvarchar(20)
	,serial nvarchar(10)
	,comp nvarchar(max)
	,addr nvarchar(max)
	,[money] decimal(25,7)
	,tax decimal(25,7)
	,total decimal(25,7)
	,n int
	,nob nvarchar(20)
    ,custno nvarchar(20)
)
declare @bbs table(
	noa nvarchar(20)
	,noq nvarchar(10)
	,invoiceType nvarchar(10)
	,yy nvarchar(10)
	,mm nvarchar(10)
	,dd nvarchar(10)
	,track nvarchar(10)
	,number nvarchar(10)
	,product nvarchar(max)
	,mount decimal(25,7)
	,price decimal(25,7)
	,[money] decimal(25,7)
	,tax decimal(25,7)
	,isTax bit
	,isZero bit
	,isNone bit
)
insert into @bbm(noa,serial,comp,addr,nob,custno)
select a.noa,isnull(b.serial,''),isnull(b.acomp,''),isnull(b.addr,''),ISNULL(a.nob,''),isnull(a.custno,'')
from vccb a
left join acomp b on a.cno=b.noa
where a.noa between @bvccbno and @evccbno
order by a.noa

insert into @bbs(noa,noq,invoiceType,yy,mm,dd,track,number
	,product,mount,price,[money],tax,isTax,isZero,isNone)
select a.noa,a.noq
	,case c.invoiceType when '07' then '一' when '08' then '特' else isnull(c.invoiceType,'') end invoiceType
	,left(a.idate,3) yy
	,SUBSTRING(a.idate,5,2) mm
	,RIGHT(a.idate,2) dd
	,LEFT(a.invono,2) track
	,RIGHT(a.invono,8)  number
	,a.product
	,a.mount
	,a.price
	,isnull(a.[total],0)
	,isnull(a.tax,0)
	,case when a.taxtype='1' or a.taxtype='3' or a.taxtype='5' then 1 else 0 end isTax
	,case when a.taxtype='2' then 1 else 0 end isZero
	,case when a.taxtype='4' then 1 else 0 end isNone
from vccbs a
left join @bbm b on a.noa=b.noa
left join vccar c on a.invono between c.binvono and c.einvono
where b.noa is not null
order by a.noa,a.noq

update @bbm set n=b.n,[money]=b.[money],tax=b.tax,total=b.total
from @bbm a
left join (select noa,count(1) n,SUM([money]) [money],SUM(tax) tax,SUM([money]+tax) total from @bbs group by noa) b on a.noa=b.noa

select noa,serial,comp,addr 
	,dbo.getComma([money],-1) 
	,dbo.getComma(tax,-1) 
	,dbo.getComma(total,-1) 
	,n
	,nob
    ,custno
from @bbm
select noa,noq,invoiceType,yy,mm,dd,track,number,product
	,dbo.getComma(mount,-1) 
	,dbo.getComma(price,-1) 
	,dbo.getComma([money],-1) 
	,dbo.getComma(tax,-1) 
	,isTax
	,isZero
	,isNone
from @bbs
                ";

                System.Data.SqlClient.SqlCommand cmd = connSource.CreateCommand();
                //System.Data.SqlClient.SqlTransaction transaction;
                //transaction = connSource.BeginTransaction("SampleTransaction");
                cmd.CommandText = query;
                cmd.Connection = connSource;
                //cmd.Transaction = transaction;
                cmd.Parameters.AddWithValue("@bvccbno", bvccbno);
                cmd.Parameters.AddWithValue("@evccbno", evccbno);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }
            Vccb[] bbm = new Vccb[ds.Tables[0].Rows.Count];
            int n = 0,m = 0;
            foreach (System.Data.DataRow r in ds.Tables[0].Rows)
            {
                bbm[n] = new Vccb();
                bbm[n].noa = System.DBNull.Value.Equals(r.ItemArray[0]) ? null : (System.String)r.ItemArray[0];
                bbm[n].serial = System.DBNull.Value.Equals(r.ItemArray[1]) ? null : (System.String)r.ItemArray[1];
                bbm[n].comp = System.DBNull.Value.Equals(r.ItemArray[2]) ? null : (System.String)r.ItemArray[2];
                bbm[n].addr = System.DBNull.Value.Equals(r.ItemArray[3]) ? null : (System.String)r.ItemArray[3];
                bbm[n].money = System.DBNull.Value.Equals(r.ItemArray[4]) ? null : (System.String)r.ItemArray[4];
                bbm[n].tax = System.DBNull.Value.Equals(r.ItemArray[5]) ? null : (System.String)r.ItemArray[5];
                bbm[n].total = System.DBNull.Value.Equals(r.ItemArray[6]) ? null : (System.String)r.ItemArray[6];
                bbm[n].n = System.DBNull.Value.Equals(r.ItemArray[7]) ? 0 : (System.Int32)r.ItemArray[7];
                bbm[n].nob = System.DBNull.Value.Equals(r.ItemArray[8]) ? null : (System.String)r.ItemArray[8];
                bbm[n].custno = System.DBNull.Value.Equals(r.ItemArray[9]) ? null : (System.String)r.ItemArray[9];
                bbm[n].bbs = new Vccbs[bbm[n].n];
                m = 0;
                foreach (System.Data.DataRow s in ds.Tables[1].Rows)
                {
                    if ((m >= bbm[n].n) || (bbm[n].noa != (System.DBNull.Value.Equals(r.ItemArray[0]) ? null : (System.String)r.ItemArray[0])))
                        continue;
                    bbm[n].bbs[m] = new Vccbs();
                    bbm[n].bbs[m].noa = System.DBNull.Value.Equals(s.ItemArray[0]) ? null : (System.String)s.ItemArray[0];
                    bbm[n].bbs[m].noq = System.DBNull.Value.Equals(s.ItemArray[1]) ? null : (System.String)s.ItemArray[1];
                    bbm[n].bbs[m].invocieType = System.DBNull.Value.Equals(s.ItemArray[2]) ? null : (System.String)s.ItemArray[2];
                    bbm[n].bbs[m].yy = System.DBNull.Value.Equals(s.ItemArray[3]) ? null : (System.String)s.ItemArray[3];
                    bbm[n].bbs[m].mm = System.DBNull.Value.Equals(s.ItemArray[4]) ? null : (System.String)s.ItemArray[4];
                    bbm[n].bbs[m].dd = System.DBNull.Value.Equals(s.ItemArray[5]) ? null : (System.String)s.ItemArray[5];
                    bbm[n].bbs[m].track = System.DBNull.Value.Equals(s.ItemArray[6]) ? null : (System.String)s.ItemArray[6];
                    bbm[n].bbs[m].number = System.DBNull.Value.Equals(s.ItemArray[7]) ? null : (System.String)s.ItemArray[7];
                    bbm[n].bbs[m].product = System.DBNull.Value.Equals(s.ItemArray[8]) ? null : (System.String)s.ItemArray[8];

                    bbm[n].bbs[m].mount = System.DBNull.Value.Equals(s.ItemArray[9]) ? null : (System.String)s.ItemArray[9];
                    bbm[n].bbs[m].price = System.DBNull.Value.Equals(s.ItemArray[10]) ? null : (System.String)s.ItemArray[10];
                    bbm[n].bbs[m].money = System.DBNull.Value.Equals(s.ItemArray[11]) ? null : (System.String)s.ItemArray[11];
                    bbm[n].bbs[m].tax = System.DBNull.Value.Equals(s.ItemArray[12]) ? null : (System.String)s.ItemArray[12];
                    
                    bbm[n].bbs[m].isTax = System.DBNull.Value.Equals(s.ItemArray[13]) ? false : (System.Boolean)s.ItemArray[13];
                    bbm[n].bbs[m].isZero = System.DBNull.Value.Equals(s.ItemArray[14]) ? false : (System.Boolean)s.ItemArray[14];
                    bbm[n].bbs[m].isNone = System.DBNull.Value.Equals(s.ItemArray[15]) ? false : (System.Boolean)s.ItemArray[15];
                    m++;
                }
                n++;
            }
           
            return bbm;
        }

        public void Template(ref iTextSharp.text.pdf.PdfContentByte cb, float width, float height, iTextSharp.text.pdf.BaseFont bfChinese)
        {
            //============ 框線 ==============
            cb.MoveTo(width / (float)21 * (float)1, height / (float)29.7 * (float)29);
            cb.LineTo(width / (float)21 * (float)1, height / (float)29.7 * (float)5.5);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)5.5);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)26);
            cb.LineTo(width / (float)21 * (float)1, height / (float)29.7 * (float)26);
            cb.MoveTo(width / (float)21 * (float)9.5, height / (float)29.7 * (float)26);
            cb.LineTo(width / (float)21 * (float)9.5, height / (float)29.7 * (float)29);
            cb.LineTo(width / (float)21 * (float)1, height / (float)29.7 * (float)29);

            cb.MoveTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)29);
            cb.LineTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)26);

            cb.MoveTo(width / (float)21 * (float)4, height / (float)29.7 * (float)29);
            cb.LineTo(width / (float)21 * (float)4, height / (float)29.7 * (float)26);
            
            cb.MoveTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)28);
            cb.LineTo(width / (float)21 * (float)9.5, height / (float)29.7 * (float)28);
            cb.MoveTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)27);
            cb.LineTo(width / (float)21 * (float)9.5, height / (float)29.7 * (float)27);
            //--------------------------------------------------------------------------
            cb.MoveTo(width / (float)21 * (float)1, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)25.3);

            cb.MoveTo(width / (float)21 * (float)1.5, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)1.5, height / (float)29.7 * (float)6.3);
            
            cb.MoveTo(width / (float)21 * (float)1.5, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)1, height / (float)29.7 * (float)23.5);
            
            cb.MoveTo(width / (float)21 * (float)1, height / (float)29.7 * (float)23.5);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)23.5);
            //年
            cb.MoveTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)2.3, height / (float)29.7 * (float)6.3);
            //月
            cb.MoveTo(width / (float)21 * (float)3, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)3, height / (float)29.7 * (float)6.3);
            //日
            cb.MoveTo(width / (float)21 * (float)3.7, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)3.7, height / (float)29.7 * (float)6.3);
            //字軌
            cb.MoveTo(width / (float)21 * (float)4.4, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)4.4, height / (float)29.7 * (float)6.3);
            //號　碼
            cb.MoveTo(width / (float)21 * (float)6, height / (float)29.7 * (float)26);
            cb.LineTo(width / (float)21 * (float)6, height / (float)29.7 * (float)6.3);
            //品　　名
            cb.MoveTo(width / (float)21 * (float)10, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)10, height / (float)29.7 * (float)6.3);
            //數　量
            cb.MoveTo(width / (float)21 * (float)11.4, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)11.4, height / (float)29.7 * (float)6.3);
            //單　價
            cb.MoveTo(width / (float)21 * (float)12.8, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)12.8, height / (float)29.7 * (float)5.5);
            //金　　額
            cb.MoveTo(width / (float)21 * (float)15.6, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)15.6, height / (float)29.7 * (float)5.5);
            //營業稅額
            cb.MoveTo(width / (float)21 * (float)17.6, height / (float)29.7 * (float)26);
            cb.LineTo(width / (float)21 * (float)17.6, height / (float)29.7 * (float)5.5);
            //應稅
            cb.MoveTo(width / (float)21 * (float)18.4, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)18.4, height / (float)29.7 * (float)6.3);
            //零稅率
            cb.MoveTo(width / (float)21 * (float)19.2, height / (float)29.7 * (float)25.3);
            cb.LineTo(width / (float)21 * (float)19.2, height / (float)29.7 * (float)6.3);
            //免稅
            cb.MoveTo(width / (float)21 * (float)1, height / (float)29.7 * (float)6.3);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)6.3);
            
            //簽章
            cb.MoveTo(width / (float)21 * (float)12, height / (float)29.7 * (float)5.4);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)5.4);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)0.5);
            cb.LineTo(width / (float)21 * (float)12, height / (float)29.7 * (float)0.5);
            cb.LineTo(width / (float)21 * (float)12, height / (float)29.7 * (float)5.4);

            cb.MoveTo(width / (float)21 * (float)12, height / (float)29.7 * (float)4.7);
            cb.LineTo(width / (float)21 * (float)20, height / (float)29.7 * (float)4.7);
            
            cb.Stroke();
            //文字
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 13);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "電子發票銷貨退回、進貨退出或折讓證明單證明聯", width / (float)21 * (float)9.7, height / (float)29.7 * (float)27.5, 0);
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "原", width / (float)21 * (float)1.2, height / (float)29.7 * (float)28.6, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "開", width / (float)21 * (float)1.2, height / (float)29.7 * (float)28, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "立", width / (float)21 * (float)1.2, height / (float)29.7 * (float)27.4, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "銷", width / (float)21 * (float)1.2, height / (float)29.7 * (float)26.8, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "貨", width / (float)21 * (float)1.2, height / (float)29.7 * (float)26.2, 0);
            
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "發", width / (float)21 * (float)1.8, height / (float)29.7 * (float)28.6, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "票", width / (float)21 * (float)1.8, height / (float)29.7 * (float)27.8, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "單", width / (float)21 * (float)1.8, height / (float)29.7 * (float)27, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "位", width / (float)21 * (float)1.8, height / (float)29.7 * (float)26.2, 0);

            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營利事業", width / (float)21 * (float)2.4, height / (float)29.7 * (float)28.6, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "統一編號", width / (float)21 * (float)2.4, height / (float)29.7 * (float)28.15, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "名　　稱", width / (float)21 * (float)2.4, height / (float)29.7 * (float)27.3, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業所在", width / (float)21 * (float)2.4, height / (float)29.7 * (float)26.55, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地　　址", width / (float)21 * (float)2.4, height / (float)29.7 * (float)26.1, 0);
            cb.SetFontAndSize(bfChinese, 12);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "開　立　發　票", width / (float)21 * (float)3.5, height / (float)29.7 * (float)25.5, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "退　貨　或　折　讓　內　容", width / (float)21 * (float)11.8, height / (float)29.7 * (float)25.5, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "課稅別（v）", width / (float)21 * (float)18.8, height / (float)29.7 * (float)25.5, 0);
            cb.SetFontAndSize(bfChinese, 6);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "一", width / (float)21 * (float)1.05, height / (float)29.7 * (float)25, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "般", width / (float)21 * (float)1.05, height / (float)29.7 * (float)24.8, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "特", width / (float)21 * (float)1.2, height / (float)29.7 * (float)23.8, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "種", width / (float)21 * (float)1.2, height / (float)29.7 * (float)23.6, 0);
            cb.SetFontAndSize(bfChinese, 12);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "年", width / (float)21 * (float)1.9, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "月", width / (float)21 * (float)2.65, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "日", width / (float)21 * (float)3.35, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "字", width / (float)21 * (float)4.05, height / (float)29.7 * (float)24.4, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "軌", width / (float)21 * (float)4.05, height / (float)29.7 * (float)23.95, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "號　碼", width / (float)21 * (float)5.2, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "品　　名", width / (float)21 * (float)8, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "數　量", width / (float)21 * (float)10.7, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "單　價", width / (float)21 * (float)12.1, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "金　　額", width / (float)21 * (float)14.2, height / (float)29.7 * (float)24.4, 0);
            cb.SetFontAndSize(bfChinese, 8);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "（不含稅之進貨金額）", width / (float)21 * (float)14.2, height / (float)29.7 * (float)23.95, 0);
            cb.SetFontAndSize(bfChinese, 12);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "營業稅額", width / (float)21 * (float)16.6, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "應", width / (float)21 * (float)18, height / (float)29.7 * (float)24.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "稅", width / (float)21 * (float)18, height / (float)29.7 * (float)23.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "零", width / (float)21 * (float)18.8, height / (float)29.7 * (float)24.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "稅", width / (float)21 * (float)18.8, height / (float)29.7 * (float)24.2, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "率", width / (float)21 * (float)18.8, height / (float)29.7 * (float)23.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "免", width / (float)21 * (float)19.6, height / (float)29.7 * (float)24.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "稅", width / (float)21 * (float)19.6, height / (float)29.7 * (float)23.7, 0);

            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "合　　　　　　　　　計", width / (float)21 * (float)5.7, height / (float)29.7 * (float)5.7, 0);
            cb.SetFontAndSize(bfChinese, 11);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "本證明單所列進貨退出或折讓，確屬事實，特此證明。", width / (float)21 * (float)1.2, height / (float)29.7 * (float)4.9, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "進貨營業人（或原買受人）蓋統一發票專用章", width / (float)21 * (float)16, height / (float)29.7 * (float)4.9, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "簽收人：", width / (float)21 * (float)1.2, height / (float)29.7 * (float)4.4, 0);
            cb.EndText();
        }
        public void Content(ref iTextSharp.text.pdf.PdfContentByte cb, float width, float height, iTextSharp.text.pdf.BaseFont bfChinese, Vccb vccb)
        {
            //內容
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, vccb.serial, width / (float)21 * (float)4.3, height / (float)29.7 * (float)28.4, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, vccb.comp, width / (float)21 * (float)4.3, height / (float)29.7 * (float)27.4, 0);
            cb.SetFontAndSize(bfChinese, 8);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, vccb.addr, width / (float)21 * (float)4.3, height / (float)29.7 * (float)26.4, 0);

            cb.SetFontAndSize(bfChinese, 8);
            float bbsH = (float)23;
            for (int i = 0; i < vccb.bbs.Length && bbsH>0; i++)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].invocieType, width / (float)21 * (float)1.25, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].yy, width / (float)21 * (float)1.9, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].mm, width / (float)21 * (float)2.65, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].dd, width / (float)21 * (float)3.35, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].track, width / (float)21 * (float)4.05, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].number, width / (float)21 * (float)5.2, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, vccb.bbs[i].product, width / (float)21 * (float)6.15, height / (float)29.7 * (float)bbsH, 0);

                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.bbs[i].mount.ToString(), width / (float)21 * (float)11.1, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.bbs[i].price.ToString(), width / (float)21 * (float)12.5, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.bbs[i].money.ToString(), width / (float)21 * (float)15.3, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.bbs[i].tax.ToString(), width / (float)21 * (float)17.3, height / (float)29.7 * (float)bbsH, 0);

                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].isTax ? "v" : "", width / (float)21 * (float)18, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].isZero ? "v" : "", width / (float)21 * (float)18.8, height / (float)29.7 * (float)bbsH, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, vccb.bbs[i].isNone ? "v" : "", width / (float)21 * (float)19.6, height / (float)29.7 * (float)bbsH, 0);
                
                bbsH -= (float)0.5;
            }
            cb.SetFontAndSize(bfChinese, 12);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.money.ToString(), width / (float)21 * (float)15.3, height / (float)29.7 * (float)5.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.tax.ToString(), width / (float)21 * (float)17.3, height / (float)29.7 * (float)5.7, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.total.ToString(), width / (float)21 * (float)19.7, height / (float)29.7 * (float)5.7, 0);

            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, vccb.nob + "("+vccb.custno+")", width / (float)21 * (float)19.7, height / (float)29.7 * (float)0.65, 0);
            cb.EndText();
        }
    </script>
