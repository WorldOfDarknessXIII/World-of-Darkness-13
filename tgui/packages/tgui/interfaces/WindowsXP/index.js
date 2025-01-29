import { Desktop } from './Desktop';
import { LoginScreen } from './LoginScreen';
export const WinXP = (props) => {
  const { data, act } = props;
  return data.logged === 0 ? (
    <LoginScreen data={data} act={act} />
  ) : (
    <Desktop data={data} act={act} />
  );
};
