import { GetIconByName } from './functions';

export const Icons = (props) => {
  const { apps, focus_ref, act } = props;
  return apps.map((app, index) => {
    return (
      app.desktop_app === 1 && (
        <Icon
          app={app}
          index={index}
          icon={GetIconByName(app.type)}
          is_Focus={focus_ref === app.reference}
          act={act}
        />
      )
    );
  });
};

const Icon = (props) => {
  const { index, app, icon, is_Focus, act } = props;
  return (
    <div
      style={{
        top: `${index * 60 + 10}px`,
      }}
      className={'icon'}
      onMouseDown={() => act('set_focus_app', { ref: app.reference })}
      onDoubleClick={() => act('launch_app', { ref: app.reference })}
    >
      <div className={'icon__img__container'}>
        <img
          style={{ opacity: is_Focus ? 0.7 : 1 }}
          src={icon}
          alt={app.title}
          className={'icon__img'}
        />
      </div>
      <div className={'icon__text__container'}>
        <div
          style={{ background: is_Focus ? '#0b61ff' : 'transparent' }}
          className={'icon__text'}
        >
          {app.title}
        </div>
      </div>
    </div>
  );
};
