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

class Dispatcher {

    public static int block_time;
    public static int change_time;
    public static int quantum;
    public List<Processor> processors;
    public List<Process> processes;

    // Compare which process has the lowest turn
    public static CompareFunc<Process> turn_compare = (a, b) => {
        return (int) (a.turn > b.turn ) - (int) (a.turn < b.turn);
    };

    // Compare which process has the lowest
    // combination of  execution time and turn
    public static CompareFunc<Process> time_compare = (a, b) => {
        return (int) (a.arrival_time > b.arrival_time) - (int) (a.arrival_time < b.arrival_time) + turn_compare (a, b);
    };

    // Dispatcher Constructor
    public Dispatcher (int processors, int quantum, int block_time, int change_time) {
        Dispatcher.block_time = block_time;
        Dispatcher.change_time = change_time;
        Dispatcher.quantum = quantum;

        // Create the processor objects
        for (int i = 0; i < processors; i++) {
            this.processors.append (new Processor (i));
        }
    }

    // Add a process to the list using the compare function to sort them
    public void add_process (string id, int execution_time, int times_blocked, int arrival_time) {
        this.processes.insert_sorted (new Process(id, execution_time, arrival_time, times_blocked, (int) this.processes.length ()), time_compare);
    }

    // Returns the best processor to use currently
    private Processor get_best (int arrival_time) {
        Processor best_processor = (this.processors.first ()).data;
        foreach (Processor processor in this.processors) {
            if (processor.current_time < best_processor.current_time  && processor.current_time >= arrival_time) {
                best_processor = processor;
            } else if (processor.current_time <= best_processor.current_time && processor.current_time < arrival_time) {
               best_processor = processor;
               break;
           }
        }
        return best_processor;
    }

    // Executes the list of processes
    public void dispatch () {
        foreach (Process process in this.processes) {
            Processor best = get_best (process.arrival_time);
            best.execute (process);
        }
    }
}
