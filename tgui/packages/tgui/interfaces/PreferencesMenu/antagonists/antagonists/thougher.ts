import { Antagonist, Category } from '../base';
import { multiline } from 'common/string';

const Thougher: Antagonist = {
  key: 'thougher',
  name: 'Thougher',
  description: [
    multiline`
      Quote people saying though or anything resembling though.
      More likely try to go on a murderbone before dying to an assistant with a flash.
    `,
  ],
  category: Category.Midround,
};

export default Thougher;
