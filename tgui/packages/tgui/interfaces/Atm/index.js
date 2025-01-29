import { AtmMain } from './AtmMain';
import { AtmLogin } from './AtmLogin';
export const AtmScreen = (props) => {
  const { data, act } = props;
  return data.logged_in ? (
    <AtmMain data={data} act={act} />
  ) : (
    <AtmLogin data={data} act={act} />
  );
};
