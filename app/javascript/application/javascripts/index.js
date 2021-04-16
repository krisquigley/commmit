import * as ActiveStorage from '@rails/activestorage';
import $ from 'jquery';
import 'bootstrap';
import { Turbo } from '@hotwired/turbo-rails';
import './_alert';
import './_autofocus';

ActiveStorage.start();
Turbo.start();
