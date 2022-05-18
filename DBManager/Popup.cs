using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace DBManager
{
    public partial class Popup : Form
    {

        string sql;
        MySqlCommand cmd;
        MySqlConnection con;

        public Popup()
        {
            InitializeComponent();
        }

        private void btnAdd_Click(object sender, EventArgs e)
        {
            string cs = @"server=localhost;userid=root;password=root;database=campionato";
            con = new MySqlConnection(cs);
            con.Open();

            sql = $"INSERT INTO tesserato VALUES (@matricola, @nome, @cognome, @nascita, @tipo, @stipendio, @scadenza, @squadra)";

            cmd = new MySqlCommand(sql, con);

            cmd.Parameters.Add("@matricola", MySqlDbType.VarChar).Value = tbMatricola.Text;
            cmd.Parameters.Add("@nome", MySqlDbType.VarChar).Value = tbNome.Text;
            cmd.Parameters.Add("@cognome", MySqlDbType.VarChar).Value = tbCognome.Text;
            cmd.Parameters.Add("@nascita", MySqlDbType.Date).Value = dtpDataNascita.Value.Date;
            cmd.Parameters.Add("@tipo", MySqlDbType.VarChar).Value = ddmTipo.Text;
            cmd.Parameters.Add("@stipendio", MySqlDbType.Int64).Value = Convert.ToInt64(tbStipendio.Text);
            cmd.Parameters.Add("@scadenza", MySqlDbType.Date).Value = dtpScadenza.Value.Date;
            cmd.Parameters.Add("@squadra", MySqlDbType.VarChar).Value = tbSquadra.Text;

            cmd.ExecuteReader();

            Close();
            DialogResult = DialogResult.OK;

        }
    }
}
