namespace DBManager
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
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
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.btnConnect = new System.Windows.Forms.Button();
            this.table = new System.Windows.Forms.DataGridView();
            this.dgrClassifica = new System.Windows.Forms.DataGridView();
            this.dropDownMenu = new System.Windows.Forms.ComboBox();
            this.lbl1 = new System.Windows.Forms.Label();
            this.btnAddRecord = new System.Windows.Forms.Button();
            this.btnDeleteRecord = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.table)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgrClassifica)).BeginInit();
            this.SuspendLayout();
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(12, 118);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(204, 29);
            this.btnConnect.TabIndex = 0;
            this.btnConnect.Text = "Connetti";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // table
            // 
            this.table.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.table.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.table.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.DisplayedCells;
            this.table.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.table.Location = new System.Drawing.Point(222, 3);
            this.table.Name = "table";
            this.table.RowHeadersWidth = 51;
            this.table.RowTemplate.Height = 29;
            this.table.Size = new System.Drawing.Size(854, 489);
            this.table.TabIndex = 2;
            // 
            // dgrClassifica
            // 
            this.dgrClassifica.AllowUserToAddRows = false;
            this.dgrClassifica.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgrClassifica.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.DisplayedHeaders;
            this.dgrClassifica.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgrClassifica.Location = new System.Drawing.Point(12, 153);
            this.dgrClassifica.Name = "dgrClassifica";
            this.dgrClassifica.RowHeadersWidth = 51;
            this.dgrClassifica.RowTemplate.Height = 29;
            this.dgrClassifica.Size = new System.Drawing.Size(204, 173);
            this.dgrClassifica.TabIndex = 3;
            // 
            // dropDownMenu
            // 
            this.dropDownMenu.Enabled = false;
            this.dropDownMenu.FormattingEnabled = true;
            this.dropDownMenu.Items.AddRange(new object[] {
            "tesserato",
            "statistiche",
            "squadra",
            "arbitro",
            "partita",
            "caratteristiche",
            "stagione",
            "vista"});
            this.dropDownMenu.Location = new System.Drawing.Point(12, 382);
            this.dropDownMenu.Name = "dropDownMenu";
            this.dropDownMenu.Size = new System.Drawing.Size(204, 28);
            this.dropDownMenu.TabIndex = 4;
            this.dropDownMenu.SelectedIndexChanged += new System.EventHandler(this.dropDownMenu_SelectedIndexChanged);
            // 
            // lbl1
            // 
            this.lbl1.AutoSize = true;
            this.lbl1.Location = new System.Drawing.Point(12, 359);
            this.lbl1.Name = "lbl1";
            this.lbl1.Size = new System.Drawing.Size(124, 20);
            this.lbl1.TabIndex = 5;
            this.lbl1.Text = "Seleziona Tabella";
            // 
            // btnAddRecord
            // 
            this.btnAddRecord.Enabled = false;
            this.btnAddRecord.Location = new System.Drawing.Point(12, 428);
            this.btnAddRecord.Name = "btnAddRecord";
            this.btnAddRecord.Size = new System.Drawing.Size(204, 29);
            this.btnAddRecord.TabIndex = 6;
            this.btnAddRecord.Text = "Aggiungi Record";
            this.btnAddRecord.UseVisualStyleBackColor = true;
            this.btnAddRecord.Click += new System.EventHandler(this.btnAddRecord_Click);
            // 
            // btnDeleteRecord
            // 
            this.btnDeleteRecord.Enabled = false;
            this.btnDeleteRecord.Location = new System.Drawing.Point(12, 463);
            this.btnDeleteRecord.Name = "btnDeleteRecord";
            this.btnDeleteRecord.Size = new System.Drawing.Size(204, 29);
            this.btnDeleteRecord.TabIndex = 7;
            this.btnDeleteRecord.Text = "Elimina Record";
            this.btnDeleteRecord.UseVisualStyleBackColor = true;
            this.btnDeleteRecord.Click += new System.EventHandler(this.btnDeleteRecord_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(88, 3);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(128, 27);
            this.textBox1.TabIndex = 8;
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(88, 36);
            this.textBox2.Name = "textBox2";
            this.textBox2.Size = new System.Drawing.Size(128, 27);
            this.textBox2.TabIndex = 9;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 10);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(50, 20);
            this.label1.TabIndex = 10;
            this.label1.Text = "Nome";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 43);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(70, 20);
            this.label2.TabIndex = 11;
            this.label2.Text = "Password";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1088, 498);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.textBox2);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.btnDeleteRecord);
            this.Controls.Add(this.btnAddRecord);
            this.Controls.Add(this.lbl1);
            this.Controls.Add(this.dropDownMenu);
            this.Controls.Add(this.dgrClassifica);
            this.Controls.Add(this.table);
            this.Controls.Add(this.btnConnect);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.table)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgrClassifica)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private Button btnConnect;
        private DataGridView table;
        private DataGridView dgrClassifica;
        private ComboBox dropDownMenu;
        private Label lbl1;
        private Button btnAddRecord;
        private Button btnDeleteRecord;
        private TextBox textBox1;
        private TextBox textBox2;
        private Label label1;
        private Label label2;
    }
}