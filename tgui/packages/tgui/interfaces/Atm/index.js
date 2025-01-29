import { AtmLogin } from './AtmLogin';
import { AtmMain } from './AtmMain';
export const AtmScreen = (props) => {
  const { data, act } = props;
  return data.logged_in ? (
    <AtmMain data={data} act={act} />
  ) : (
    <AtmLogin data={data} act={act} />
  );
};
