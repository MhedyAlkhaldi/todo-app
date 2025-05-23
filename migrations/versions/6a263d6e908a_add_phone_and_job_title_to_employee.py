"""Add phone and job_title to Employee

Revision ID: 6a263d6e908a
Revises: 4342cc1e64bd
Create Date: 2025-05-05 11:38:11.361354

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '6a263d6e908a'
down_revision: Union[str, None] = '4342cc1e64bd'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.add_column('employee', sa.Column('phone', sa.String(length=20), nullable=True))
    op.add_column('employee', sa.Column('job_title', sa.String(length=100), nullable=True))
    # ### end Alembic commands ###


def downgrade() -> None:
    """Downgrade schema."""
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_column('employee', 'job_title')
    op.drop_column('employee', 'phone')
    # ### end Alembic commands ###
