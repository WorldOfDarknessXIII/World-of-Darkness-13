import { HeaderButtons } from './HeaderButtons';
import { Component } from 'react';
import { noop } from './constants';
import { GetIconByName, GetAppByName } from '../functions';

export class Window extends Component {
  constructor() {
    super();
    this.state = {
      isDragging: false,
      dragPos: null,
      startPos: null,
      lastMousePos: null,
    };

    this.handleStartDrag = this.handleStartDrag.bind(this);
    this.handleStopDrag = this.handleStopDrag.bind(this);
    this.handleDrag = this.handleDrag.bind(this);
  }

  handleStartDrag(e) {
    const { app, act, is_Focus } = this.props;
    !is_Focus && act('set_current_app', { ref: app.reference });
    e.stopPropagation();
    this.setState({
      lastMousePos: null,
      isDragging: true,
      dragPos: { x: app.x, y: app.y },
      startPos: { x: app.x, y: app.y },
    });
    window.addEventListener('mousemove', this.handleDrag);
    window.addEventListener('mouseup', this.handleStopDrag);
  }

  handleStopDrag(e) {
    const { dragPos } = this.state;
    const { app, act } = this.props;
    if (dragPos) {
      act('set_app_cords', {
        ref: app.reference,
        rel_x: dragPos.x,
        rel_y: dragPos.y,
      });
    }

    window.removeEventListener('mousemove', this.handleDrag);
    window.removeEventListener('mouseup', this.handleStopDrag);
    this.setState({ isDragging: false });
  }

  handleDrag(e) {
    const { dragPos, isDragging, lastMousePos } = this.state;
    if (dragPos && isDragging) {
      e.preventDefault();
      const { screenZoomX, screenZoomY, screenX, screenY } = e;
      let xPos = screenZoomX || screenX;
      let yPos = screenZoomY || screenY;
      if (lastMousePos) {
        let rel_x = dragPos.x - (lastMousePos.x - xPos);
        let rel_y = dragPos.y - (lastMousePos.y - yPos);
        this.setState({
          dragPos: {
            x: rel_x,
            y: rel_y,
          },
        });
      }
      this.setState({
        lastMousePos: { x: xPos, y: yPos },
      });
    }
  }

  render() {
    const { app, is_Focus, act = noop, ...rest } = this.props;
    const { startPos, dragPos } = this.state;
    let [x_pos, y_pos] = [app.x, app.y];
    if (dragPos && startPos && startPos.x === x_pos && startPos.y === y_pos) {
      x_pos = dragPos.x;
      y_pos = dragPos.y;
    }
    return (
      <div
        onMouseDown={
          is_Focus
            ? () => {}
            : () => act('set_current_app', { ref: app.reference })
        }
        className={'window'}
        style={{
          width: `${app.width}px`,
          height: `${app.height}px`,
          left: `${x_pos}px`,
          top: `${y_pos}px`,
          display: app.minimized ? 'none' : 'flex',
          background: is_Focus ? '#0831d9' : '#6582f5',
        }}
      >
        <div
          className={'header__bg'}
          style={{
            background: is_Focus
              ? 'linear-gradient(to bottom,#0058ee 0%,#3593ff 4%,#288eff 6%,#127dff 8%,#036ffc 10%,#0262ee 14%,#0057e5 20%,#0054e3 24%,#0055eb 56%,#005bf5 66%,#026afe 76%,#0062ef 86%,#0052d6 92%,#0040ab 94%,#003092 100%)'
              : 'linear-gradient(to bottom, #7697e7 0%,#7e9ee3 3%,#94afe8 6%,#97b4e9 8%,#82a5e4 14%,#7c9fe2 17%,#7996de 25%,#7b99e1 56%,#82a9e9 81%,#80a5e7 89%,#7b96e1 94%,#7a93df 97%,#abbae3 100%)',
            opacity: is_Focus ? 1 : 0.3,
          }}
        />
        <header
          className="app__header"
          onMouseDown={this.handleStartDrag}
          onMouseUp={this.handleStopDrag}
          onComponentWillUnmount={this.handleDrag}
          {...rest}
        >
          <img
            src={GetIconByName(app.type)}
            alt=""
            className="app__header__icon"
          />
          <div className="app__header__title">{app.title}</div>
          <HeaderButtons
            is_Focus={is_Focus}
            close
            minimize
            maximize
            on_minimize={() => {
              act('minimize', { ref: app.reference });
            }}
            on_maximize={() => {
              act('maximize', { ref: app.reference });
            }}
            on_close={() => {
              act('close', { ref: app.reference });
            }}
          />
        </header>
        <div className="app__content">{GetAppByName(app, act)}</div>
      </div>
    );
  }
}
