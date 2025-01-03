import { AtmMain } from './AtmMain';
import { AtmLogin } from './AtmLogin';
export const AtmScreen = props => {
  const { data, act } = props;
  return ((
    data.logged_in
      ? <AtmLogin data={data} act={act} />
      : <AtmMain data={data} act={act} />
  ));
};
