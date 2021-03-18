import * as ActiveStorage from '@rails/activestorage';
import 'bootstrap';
import { Turbo } from '@hotwired/turbo-rails';

ActiveStorage.start();
Turbo.start();
