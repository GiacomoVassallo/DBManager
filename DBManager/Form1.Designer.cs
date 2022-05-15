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
            ((System.ComponentModel.ISupportInitialize)(this.table)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgrClassifica)).BeginInit();
            this.SuspendLayout();
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(12, 3);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(93, 29);
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
            this.table.Location = new System.Drawing.Point(280, 3);
            this.table.Name = "table";
            this.table.RowHeadersWidth = 51;
            this.table.RowTemplate.Height = 29;
            this.table.Size = new System.Drawing.Size(1114, 489);
            this.table.TabIndex = 2;
            // 
            // dgrClassifica
            // 
            this.dgrClassifica.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.Fill;
            this.dgrClassifica.AutoSizeRowsMode = System.Windows.Forms.DataGridViewAutoSizeRowsMode.DisplayedCells;
            this.dgrClassifica.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgrClassifica.Location = new System.Drawing.Point(12, 215);
            this.dgrClassifica.Name = "dgrClassifica";
            this.dgrClassifica.RowHeadersWidth = 51;
            this.dgrClassifica.RowTemplate.Height = 29;
            this.dgrClassifica.Size = new System.Drawing.Size(262, 277);
            this.dgrClassifica.TabIndex = 3;
            // 
            // dropDownMenu
            // 
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
            this.dropDownMenu.Location = new System.Drawing.Point(111, 3);
            this.dropDownMenu.Name = "dropDownMenu";
            this.dropDownMenu.Size = new System.Drawing.Size(163, 28);
            this.dropDownMenu.TabIndex = 4;
            this.dropDownMenu.Visible = false;
            this.dropDownMenu.SelectedIndexChanged += new System.EventHandler(this.dropDownMenu_SelectedIndexChanged);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1397, 515);
            this.Controls.Add(this.dropDownMenu);
            this.Controls.Add(this.dgrClassifica);
            this.Controls.Add(this.table);
            this.Controls.Add(this.btnConnect);
            this.Name = "Form1";
            this.Text = "Form1";
            ((System.ComponentModel.ISupportInitialize)(this.table)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dgrClassifica)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private Button btnConnect;
        private DataGridView table;
        private DataGridView dgrClassifica;
        private ComboBox dropDownMenu;
    }
}