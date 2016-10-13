/* Copyright 2016 
* 
* Diego Islas Ocampo
* Luis Fernando Saavedra
*
* This file is part of Dispatcher.
*
* Dispatcher is free software: you can redistribute it
* and/or modify it under the terms of the GNU General Public License as
* published by the Free Software Foundation, either version 3 of the
* License, or (at your option) any later version.
*
* Dispatcher is distributed in the hope that it will be
* useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with Dispatcher. If not, see http://www.gnu.org/licenses/.
*/

using Gtk;

public class Main : Gtk.Window {
	public Main () {
		// Prepare Gtk.Window:
		this.title = "Dispatcher";
		this.window_position = Gtk.WindowPosition.CENTER;
		this.destroy.connect (Gtk.main_quit);
		this.set_default_size (800, 600);


		Gtk.Box container = new Gtk.Box (Orientation.VERTICAL, 10);
		container.margin = 20;

		Gtk.Box inputs = new Gtk.Box (Orientation.HORIZONTAL, 10);


		Gtk.Label processors_label = new Gtk.Label ("Processors: ");
		Gtk.SpinButton processors = new Gtk.SpinButton.with_range (1, 1000, 1);

		inputs.add (processors_label);
		inputs.add (processors);


		Gtk.Label quantum_label = new Gtk.Label ("Quantum: ");
		Gtk.SpinButton quantum = new Gtk.SpinButton.with_range (1, 1000000, 1);
		quantum.input_purpose = Gtk.InputPurpose.NUMBER;

		inputs.add (quantum_label);
		inputs.add (quantum);


		Gtk.Label tb_label = new Gtk.Label ("TB: ");
		Gtk.SpinButton tb = new Gtk.SpinButton.with_range (0, 1000, 1);
		tb.input_purpose = Gtk.InputPurpose.NUMBER;

		inputs.add (tb_label);
		inputs.add (tb);

		Gtk.Label tcc_label = new Gtk.Label ("TCC: ");
		Gtk.SpinButton tcc = new Gtk.SpinButton.with_range (0, 1000, 1);
		tcc.input_purpose = Gtk.InputPurpose.NUMBER;

		inputs.add (tcc_label);
		inputs.add (tcc);

		Gtk.Button load = new Gtk.Button.with_label ("Load");



		inputs.add (load);


		Gtk.Button run = new Gtk.Button.with_label ("Run");

		inputs.add (run);



		container.add (inputs);

		Gtk.Box areas = new Gtk.Box (Orientation.HORIZONTAL, 5);

		areas.hexpand = true;

		Gtk.TextView processes = new Gtk.TextView ();
		processes.expand = true;

		Box scroll = new Box (Orientation.VERTICAL, 20);


		load.clicked.connect(() => {
			var file_chooser = new FileChooserDialog ("Open File", this,
	                                      FileChooserAction.OPEN,
	                                      "_Cancel", ResponseType.CANCEL,
	                                      "_Open", ResponseType.ACCEPT);
	        if (file_chooser.run () == ResponseType.ACCEPT) {

	        	 try {
		            string text;
		            FileUtils.get_contents (file_chooser.get_filename (), out text);
		            processes.buffer.text = text;
		        } catch (Error e) {
		            stderr.printf ("Error: %s\n", e.message);
		        }
	        }
	        file_chooser.destroy ();
		});

		Gtk.ScrolledWindow content= new Gtk.ScrolledWindow(null, null);
		content.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC);
		content.add (scroll);

		areas.add (processes);
		areas.add (content);

		container.add (areas);

		run.clicked.connect (() => {
			var children = scroll.get_children ();

			children.foreach((child)=>{
				scroll.remove (child);
			});

			int processors_value = processors.get_value_as_int ();
			int quantum_value = quantum.get_value_as_int ();
			int tb_value = tb.get_value_as_int ();
			int tcc_value = tcc.get_value_as_int ();

			Dispatcher dispatcher = new Dispatcher (processors_value, quantum_value, tb_value, tcc_value);

			string[] text = processes.buffer.text.split ("\n");

			foreach (string entry in text) {
				string[] values = entry.strip().split (" ");

				if (values.length == 4) {
					string id = values[0];
					int te = int.parse (values[1]);
					int times_blocked = int.parse (values[2]);
					int arrived_at = int.parse (values[3]);
					dispatcher.add_process (id, te, times_blocked, arrived_at);
				}
			}

			dispatcher.dispatch ();



			foreach (Processor processor in dispatcher.processors) {
				Gtk.Grid results = new Gtk.Grid ();

				results.row_spacing = 10;
				results.column_homogeneous = true;

				results.attach (new Gtk.Label ("Procesador # " + (processor.id + 1).to_string ()), 0, 0, 8, 1);
				results.attach (new Gtk.Label ("Proceso"), 0, 1, 1, 1);
				results.attach (new Gtk.Label ("TCC"), 1, 1, 1, 1);
				results.attach (new Gtk.Label ("TE"), 2, 1, 1, 1);
				results.attach (new Gtk.Label ("TVC"), 3, 1, 1, 1);
				results.attach (new Gtk.Label ("TB"), 4, 1, 1, 1);
				results.attach (new Gtk.Label ("TT"), 5, 1, 1, 1);
				results.attach (new Gtk.Label ("TI"), 6, 1, 1, 1);
				results.attach (new Gtk.Label ("TF"), 7, 1, 1, 1);

		  		results.expand = true;
		  		int count = 2;
		  		foreach (Entry entry in processor.entries) {

		  			if (entry.process != null) {
		  				results.attach (new Gtk.Label (entry.process.id), 0, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.tcc.to_string ()), 1, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.te.to_string ()), 2, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.tvc.to_string ()), 3, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.tb.to_string ()), 4, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.tt.to_string ()), 5, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.ti.to_string ()), 6, count, 1, 1);
			  			results.attach (new Gtk.Label (entry.tf.to_string ()), 7, count, 1, 1);
		  			} else {
		  				results.attach (new Gtk.Label (""), 0, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 1, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 2, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 3, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 4, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 5, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 6, count, 1, 1);
			  			results.attach (new Gtk.Label (""), 7, count, 1, 1);

		  			}

		  			count ++;
		  		}

		  		//results.enable_grid_lines = true;

		  		scroll.add (results);
		  		scroll.show_all ();
			}


		});


		this.add (container);

	}

	public static int main (string[] args) {
		Gtk.init (ref args);

		Main app = new Main ();
		app.show_all ();
		Gtk.main ();
		return 0;
	}
}

