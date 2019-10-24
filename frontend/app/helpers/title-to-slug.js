import { helper } from '@ember/component/helper';
import slugify from 'ember-slugify';

export default helper(function titleToSlug([title]) {
  return slugify(title);
});
