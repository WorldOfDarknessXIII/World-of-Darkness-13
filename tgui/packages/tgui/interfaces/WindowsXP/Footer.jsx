import startButton from '../../assets/WindowsXP/start.png';
import sound from '../../assets/WindowsXP/690(16x16).png';
import usb from '../../assets/WindowsXP/394(16x16).png';
import risk from '../../assets/WindowsXP/229(16x16).png';
import { GetIconByName } from './functions';

export const Footer = (props) => {
  const { apps, current_app, act } = props;
  const getTime = () => {
    const date = new Date();
    let hour = date.getHours();
    let hourPostFix = 'AM';
    let min = date.getMinutes();
    if (hour >= 12) {
      hour -= 12;
      hourPostFix = 'PM';
    }
    if (hour === 0) {
      hour = 12;
    }
    if (min < 10) {
      min = '0' + min;
    }
    return `${hour}:${min} ${hourPostFix}`;
  };

  return (
    <div className="footer">
      <div className="footer__items left">
        <img src={startButton} alt="start" className="footer__start" />
        {apps.map((app) => {
          return (
            app.launched === 1 && (
              <FooterApp
                reference={app.reference}
                icon={GetIconByName(app.type)}
                title={app.title}
                isFocus={app.reference === current_app}
                act={act}
              />
            )
          );
        })}
      </div>
      <div className="footer__items right">
        <img className="footer__icon" src={sound} alt="" />
        <img className="footer__icon" src={usb} alt="" />
        <img className="footer__icon" src={risk} alt="" />
        <div className="footer__time">{getTime()}</div>
      </div>
    </div>
  );
};

const FooterApp = (props) => {
  const { reference, icon, title, isFocus, act } = props;
  return (
    <div
      onClick={() =>
        isFocus
          ? act('minimize', { ref: reference })
          : act('set_current_app', { ref: reference })
      }
      className={`footer__window ${isFocus ? 'focus' : 'cover'}`}
    >
      <img className="footer__icon" src={icon} alt={title} />
      <div className="footer__text">{title}</div>
    </div>
  );
};
