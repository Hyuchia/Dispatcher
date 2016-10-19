import { Component, ViewEncapsulation } from '@angular/core';
import { FormBuilder, FormGroup } from '@angular/forms';
import { Dispatcher, Processor } from './models/model';

enum AppStates {Present, Configure, Terminate};

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css'],
  encapsulation: ViewEncapsulation.None
})
export class AppComponent {

    //Initialize app state
    app_state: number = AppStates.Present;

    //This is the configuration form
    configForm: FormGroup;

    //This is the dispatcher
    dispatcher: Dispatcher;

    //These are the processors used
    processors_list: Array<Processor>;

    //Results to be displayed
    resultConfig: any = {
        processors: null,
        quantum: null,
        block_time: null,
        change_time: null,
        processess: null
    };

    constructor(fb: FormBuilder) {
        this.configForm = fb.group({
            processors: 2,
            quantum: 3000,
            block_time: 15,
            change_time: 15,
            processess: `B 300 2 0
            D 100 2 0
            F 500 3 0
            H 700 4 0
            J 300 2 1500
            L 3000 5 1500
            N 50 2 1500
            O 600 3 1500
            A 400 2 3000
            C 50 2 3000
            E 1000 5 3000
            G 10 2 3000
            I 450 3 3000
            K 100 2 4000
            M 80 2 4000
            P 800 4 4000
            Ñ 500 3 8000
            `
        });
    }

    isConfiguring(){
        return this.app_state == 1 ? true : false;
    }

    isTerminated(){
        return this.app_state == 2 ? true : false;
    }

    nextSection(next: string){
        this.app_state = AppStates[next];
    }

    isFilled(input){
        return input.value != '';
    }

    dispatch(){

        //Save reference to configuration form data
        let config = this.configForm.value;

        //Initialize dispatcher
        this.dispatcher = new Dispatcher(config.processors, config.quantum, config.block_time, config.change_time);

        //Get individual proccesses from form data
        let process_list: Array<string> = config.processess.trim().split("\n");

        //Add every process to dispatcher
        for(let process of process_list){
            let p: Array<string> = process.trim().split(" ");

            this.dispatcher.add_process(p[0], parseInt(p[1]), parseInt(p[3]), parseInt(p[2]));
        }

        //Dispatch
        this.dispatcher.dispatch();

        this.displayResults(process_list.length);

        //Continue to termination app state
        this.nextSection('Terminate');
    }

    displayResults(processess_length){
        //Get dispatcher data
        let config = this.configForm.value
        this.resultConfig = {
            processors: config.processors,
            quantum: config.quantum,
            block_time: config.block_time,
            change_time: config.change_time,
            processess: processess_length
        }

        //Get dispatcher processors
        this.processors_list = this.dispatcher.processors;
    }
}
