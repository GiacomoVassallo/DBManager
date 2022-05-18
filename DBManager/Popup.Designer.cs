namespace DBManager
{
    partial class Popup
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblMatricola = new System.Windows.Forms.Label();
            this.tbMatricola = new System.Windows.Forms.TextBox();
            this.tbNome = new System.Windows.Forms.TextBox();
            this.lblNome = new System.Windows.Forms.Label();
            this.tbCognome = new System.Windows.Forms.TextBox();
            this.lblCognome = new System.Windows.Forms.Label();
            this.dtpDataNascita = new System.Windows.Forms.DateTimePicker();
            this.lblNascita = new System.Windows.Forms.Label();
            this.ddmTipo = new System.Windows.Forms.ComboBox();
            this.lblTipo = new System.Windows.Forms.Label();
            this.tbStipendio = new System.Windows.Forms.TextBox();
            this.lblStipendio = new System.Windows.Forms.Label();
            this.lblScadenza = new System.Windows.Forms.Label();
            this.dtpScadenza = new System.Windows.Forms.DateTimePicker();
            this.tbSquadra = new System.Windows.Forms.TextBox();
            this.lblSquadra = new System.Windows.Forms.Label();
            this.btnAdd = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblMatricola
            // 
            this.lblMatricola.AutoSize = true;
            this.lblMatricola.Location = new System.Drawing.Point(7, 22);
            this.lblMatricola.Name = "lblMatricola";
            this.lblMatricola.Size = new System.Drawing.Size(72, 20);
            this.lblMatricola.TabIndex = 0;
            this.lblMatricola.Text = "Matricola";
            // 
            // tbMatricola
            // 
            this.tbMatricola.Location = new System.Drawing.Point(107, 15);
            this.tbMatricola.Name = "tbMatricola";
            this.tbMatricola.Size = new System.Drawing.Size(250, 27);
            this.tbMatricola.TabIndex = 1;
            // 
            // tbNome
            // 
            this.tbNome.Location = new System.Drawing.Point(107, 48);
            this.tbNome.Name = "tbNome";
            this.tbNome.Size = new System.Drawing.Size(250, 27);
            this.tbNome.TabIndex = 3;
            // 
            // lblNome
            // 
            this.lblNome.AutoSize = true;
            this.lblNome.Location = new System.Drawing.Point(7, 55);
            this.lblNome.Name = "lblNome";
            this.lblNome.Size = new System.Drawing.Size(50, 20);
            this.lblNome.TabIndex = 2;
            this.lblNome.Text = "Nome";
            // 
            // tbCognome
            // 
            this.tbCognome.Location = new System.Drawing.Point(107, 81);
            this.tbCognome.Name = "tbCognome";
            this.tbCognome.Size = new System.Drawing.Size(250, 27);
            this.tbCognome.TabIndex = 5;
            // 
            // lblCognome
            // 
            this.lblCognome.AutoSize = true;
            this.lblCognome.Location = new System.Drawing.Point(7, 88);
            this.lblCognome.Name = "lblCognome";
            this.lblCognome.Size = new System.Drawing.Size(74, 20);
            this.lblCognome.TabIndex = 4;
            this.lblCognome.Text = "Cognome";
            // 
            // dtpDataNascita
            // 
            this.dtpDataNascita.Location = new System.Drawing.Point(107, 114);
            this.dtpDataNascita.MinDate = new System.DateTime(1960, 1, 1, 0, 0, 0, 0);
            this.dtpDataNascita.Name = "dtpDataNascita";
            this.dtpDataNascita.Size = new System.Drawing.Size(250, 27);
            this.dtpDataNascita.TabIndex = 6;
            // 
            // lblNascita
            // 
            this.lblNascita.AutoSize = true;
            this.lblNascita.Location = new System.Drawing.Point(7, 121);
            this.lblNascita.Name = "lblNascita";
            this.lblNascita.Size = new System.Drawing.Size(94, 20);
            this.lblNascita.TabIndex = 7;
            this.lblNascita.Text = "Data Nascita";
            // 
            // ddmTipo
            // 
            this.ddmTipo.FormattingEnabled = true;
            this.ddmTipo.Items.AddRange(new object[] {
            "Giocatore",
            "Allenatore"});
            this.ddmTipo.Location = new System.Drawing.Point(107, 147);
            this.ddmTipo.Name = "ddmTipo";
            this.ddmTipo.Size = new System.Drawing.Size(250, 28);
            this.ddmTipo.TabIndex = 8;
            // 
            // lblTipo
            // 
            this.lblTipo.AutoSize = true;
            this.lblTipo.Location = new System.Drawing.Point(7, 155);
            this.lblTipo.Name = "lblTipo";
            this.lblTipo.Size = new System.Drawing.Size(39, 20);
            this.lblTipo.TabIndex = 9;
            this.lblTipo.Text = "Tipo";
            // 
            // tbStipendio
            // 
            this.tbStipendio.Location = new System.Drawing.Point(107, 181);
            this.tbStipendio.Name = "tbStipendio";
            this.tbStipendio.Size = new System.Drawing.Size(250, 27);
            this.tbStipendio.TabIndex = 11;
            // 
            // lblStipendio
            // 
            this.lblStipendio.AutoSize = true;
            this.lblStipendio.Location = new System.Drawing.Point(7, 188);
            this.lblStipendio.Name = "lblStipendio";
            this.lblStipendio.Size = new System.Drawing.Size(73, 20);
            this.lblStipendio.TabIndex = 10;
            this.lblStipendio.Text = "Stipendio";
            // 
            // lblScadenza
            // 
            this.lblScadenza.AutoSize = true;
            this.lblScadenza.Location = new System.Drawing.Point(7, 221);
            this.lblScadenza.Name = "lblScadenza";
            this.lblScadenza.Size = new System.Drawing.Size(72, 20);
            this.lblScadenza.TabIndex = 13;
            this.lblScadenza.Text = "Scadenza";
            // 
            // dtpScadenza
            // 
            this.dtpScadenza.Location = new System.Drawing.Point(107, 214);
            this.dtpScadenza.Name = "dtpScadenza";
            this.dtpScadenza.Size = new System.Drawing.Size(250, 27);
            this.dtpScadenza.TabIndex = 12;
            // 
            // tbSquadra
            // 
            this.tbSquadra.Location = new System.Drawing.Point(107, 247);
            this.tbSquadra.Name = "tbSquadra";
            this.tbSquadra.Size = new System.Drawing.Size(250, 27);
            this.tbSquadra.TabIndex = 15;
            // 
            // lblSquadra
            // 
            this.lblSquadra.AutoSize = true;
            this.lblSquadra.Location = new System.Drawing.Point(7, 254);
            this.lblSquadra.Name = "lblSquadra";
            this.lblSquadra.Size = new System.Drawing.Size(64, 20);
            this.lblSquadra.TabIndex = 14;
            this.lblSquadra.Text = "Squadra";
            // 
            // btnAdd
            // 
            this.btnAdd.Location = new System.Drawing.Point(107, 280);
            this.btnAdd.Name = "btnAdd";
            this.btnAdd.Size = new System.Drawing.Size(146, 29);
            this.btnAdd.TabIndex = 16;
            this.btnAdd.Text = "Aggiungi";
            this.btnAdd.UseVisualStyleBackColor = true;
            this.btnAdd.Click += new System.EventHandler(this.btnAdd_Click);
            // 
            // Popup
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(397, 322);
            this.Controls.Add(this.btnAdd);
            this.Controls.Add(this.tbSquadra);
            this.Controls.Add(this.lblSquadra);
            this.Controls.Add(this.lblScadenza);
            this.Controls.Add(this.dtpScadenza);
            this.Controls.Add(this.tbStipendio);
            this.Controls.Add(this.lblStipendio);
            this.Controls.Add(this.lblTipo);
            this.Controls.Add(this.ddmTipo);
            this.Controls.Add(this.lblNascita);
            this.Controls.Add(this.dtpDataNascita);
            this.Controls.Add(this.tbCognome);
            this.Controls.Add(this.lblCognome);
            this.Controls.Add(this.tbNome);
            this.Controls.Add(this.lblNome);
            this.Controls.Add(this.tbMatricola);
            this.Controls.Add(this.lblMatricola);
            this.Name = "Popup";
            this.Text = "Popup";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Label lblMatricola;
        private TextBox tbMatricola;
        private TextBox tbNome;
        private Label lblNome;
        private TextBox tbCognome;
        private Label lblCognome;
        private DateTimePicker dtpDataNascita;
        private Label lblNascita;
        private ComboBox ddmTipo;
        private Label lblTipo;
        private TextBox tbStipendio;
        private Label lblStipendio;
        private Label lblScadenza;
        private DateTimePicker dtpScadenza;
        private TextBox tbSquadra;
        private Label lblSquadra;
        private Button btnAdd;
    }
}