import { Component, OnChanges, Input } from '@angular/core';
import { Processor, Process, Entry } from '../models/model';

@Component({
  selector: 'app-processor',
  templateUrl: './processor.component.html'
})
export class ProcessorComponent implements OnChanges{

    @Input() processor: Processor;

    entries: Array<Entry>;

    constructor(){

    }

    ngOnChanges(){
        this.entries = this.processor.entries.slice(1);;
    }
}
