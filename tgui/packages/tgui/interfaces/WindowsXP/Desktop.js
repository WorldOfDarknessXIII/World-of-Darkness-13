import windowsLogo from '../../assets/bg-windows.jpg';
import { Footer } from './Footer';
import { Icons } from './Icons';
import { Windows } from './Windows/Windows';

export const Desktop = (props) => {
  const { data, act } = props;
  const { apps, focus_ref, current_app } = data;

  return (
    <div>
      <div className="desktop">
        <img src={windowsLogo} width="100%" />
        <Icons apps={apps} focus_ref={focus_ref} act={act} />
        {apps.length > 0 && (
          <Windows apps={apps} current_app={current_app} act={act} />
        )}
      </div>
      <Footer apps={apps} current_app={current_app} act={act} />
    </div>
  );
};
