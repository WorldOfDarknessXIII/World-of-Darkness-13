
import error_icon from '../../../assets/WindowsXP/897(32x32).png';

export const Error = props => {
  const { app, act } = props;
  return (
    <div className="error_popup">
      <div className="error__top">
        <img src={error_icon} alt="error" className="error__img" />
        <div className="error__messages">{app.error_message}</div>
      </div>
      <div className="error__bottom">
        <div onClick={() => act("close", { ref: app.reference })} className="error__button">
          <span className="error__confirm">OK</span>
        </div>
      </div>
    </div>
  );
};

