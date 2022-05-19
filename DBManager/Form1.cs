using System.Data.SqlClient;
using MySql.Data.MySqlClient;

namespace DBManager
{
    public partial class Form1 : Form
    {

        string sql;
        MySqlCommand cmd;
        MySqlConnection con;

        public Form1()
        {
            InitializeComponent();
        }

        private void btnConnect_Click(object sender, EventArgs e)
        {

            try {
                string cs = $"server=localhost;userid={tbNome.Text};password={tbPassword.Text};database=campionato";
                con = new MySqlConnection(cs);
                con.Open();

                cmd = new MySqlCommand("sp_stampaClassifica", con) { CommandType = System.Data.CommandType.StoredProcedure };
                cmd.Parameters.Add("Anno", MySqlDbType.VarChar).Value = "2022";

                initializeTable(dgrClassifica, cmd.ExecuteReader());

                dropDownMenu.Enabled = true;
            }
            catch (MySqlException ex)
            {
                MessageBox.Show("Errore! Il login non è valido!\n" +
                                "Si può stabilire una connessione solo se username e password sono corretti.");
                
                dropDownMenu.Enabled = false;
                btnAddRecord.Enabled = false;
                btnDeleteRecord.Enabled = false;
            }

        }

        void initializeTable(DataGridView table, MySqlDataReader rdr)
        {
            table.DataSource = null;
            table.Rows.Clear();
            this.Controls.Add(table);

            table.ColumnCount = rdr.FieldCount;


            table.ColumnHeadersDefaultCellStyle.BackColor = Color.Navy;
            table.ColumnHeadersDefaultCellStyle.ForeColor = Color.White;
            table.ColumnHeadersDefaultCellStyle.Font = new Font(table.Font, FontStyle.Bold);
            table.AutoSizeRowsMode = DataGridViewAutoSizeRowsMode.DisplayedCellsExceptHeaders;
            table.ColumnHeadersBorderStyle = DataGridViewHeaderBorderStyle.Single;
            table.CellBorderStyle = DataGridViewCellBorderStyle.Single;
            table.GridColor = Color.Black;
            table.RowHeadersVisible = false;


            for (int i = 0; i < rdr.FieldCount; i++)
            {
                table.Columns[i].Name = $"{rdr.GetName(i)}";
            }

            string item = "";
            while (rdr.Read())
            {
                List<string> listRow = new List<string>();
                for (int i = 0; i < rdr.FieldCount; i++)
                {
                    if(rdr.IsDBNull(i)) item = "NaN";
                    else item = rdr.GetString(i);
                    listRow.Add(item);
                }
                string[] row = listRow.ToArray();
                table.Rows.Add(row);
            }

            rdr.Close();
        }

        private void dropDownMenu_SelectedIndexChanged(object sender, EventArgs e)
        {

            string dataTable = dropDownMenu.Text;
            if(dataTable != null)
            {

                if (dataTable.Equals("vista"))
                {
                    dataTable = "v_statistichestagionali";
                }

                sql = $"SELECT * FROM {dataTable}";
                cmd = new MySqlCommand(sql, con);

                initializeTable(table, cmd.ExecuteReader());
            }

            if (dataTable.Equals("tesserato"))
            {
                btnAddRecord.Enabled = true;
                btnDeleteRecord.Enabled = true;
            } else
            {
                btnAddRecord.Enabled = false;
                btnDeleteRecord.Enabled = false;
            }

        }

        private void btnDeleteRecord_Click(object sender, EventArgs e)
        {

            sql = $"DELETE FROM tesserato ORDER BY codicetessera DESC LIMIT 1";
            cmd = new MySqlCommand(sql, con);

            initializeTable(table, cmd.ExecuteReader());

        }

        private void btnAddRecord_Click(object sender, EventArgs e)
        {
            Popup popup = new Popup();
            DialogResult dialogresult = popup.ShowDialog();
            if (dialogresult == DialogResult.OK) initializeTable(table, cmd.ExecuteReader());
            dropDownMenu.Items.Clear();
        }

    }
}
